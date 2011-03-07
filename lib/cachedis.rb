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
    redis.expire key, options[:expire] || 60 * 60 # set expire to user specified or one minute
  end

  def redis(options = {})
    @redis_instance ||= Redis.new(options)
  end
end
