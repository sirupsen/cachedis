require 'redis'
require 'yaml'

class Cachedis
  attr_reader :redis_instance

  def initialize(options = {})
    redis(options)
  end

  def cachedis(key, options = {}, &block)
    result = yield
    
    return redis.get key if redis.exists key

    result = result.to_yaml
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
    cachedis = Cachedis.new(options.merge((CACHEDIS_OPTIONS if defined?(CACHEDIS_OPTIONS))|| {}))
    cachedis.cachedis(name, options, &block)
  end
end
