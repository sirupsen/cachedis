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

    redis.set key, result.to_yaml
    pass_options_to_redis(options)
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
