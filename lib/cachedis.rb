require 'redis'
require 'yaml'

class Cachedis
  attr_reader :redis_instance

  def initialize(options = {})
    redis(options)
  end

  def cachedis(key, options = {}, &block)
    result = yield
    
    return Marshal.load(redis.get(key)) if redis.exists key

    result = Marshal.dump(result)
    redis.set key, result
    pass_options_to_redis(options)

    result
  end

  def redis(options = {})
    @redis_instance ||= Redis.new(options)
  end

  private
  def pass_options_to_redis(options)
    options.each do |option, argument|
      arguments = *[argument] if argument.is_a?(Array)
      redis.send(option, arguments || argument)
    end
  end
end

module CachedisInterface
  def self.cachedis(name, options = {}, &block)
    cachedis = Cachedis.new((CACHEDIS_DEFAULT_OPTIONS if defined?(CACHEDIS_DEFAULT_OPTIONS))|| {})
    
    query_options = ((CACHEDIS_DEFAULT_QUERY_OPTIONS if defined?(CACHEDIS_OPTIONS)) || {}).merge(options)
    cachedis.cachedis(name, query_options, &block)
  end
end
