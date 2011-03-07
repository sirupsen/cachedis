require 'redis'
require 'yaml'

class Cachedis
  attr_reader :redis_instance

  def initialize(options = {})
    redis(options)
  end

  def cachedis(name, options = {}, &block)
    result = yield
    
    return redis.get name if redis.exists name

    redis.set name, result.to_yaml
    redis.expire name, options[:expire] || 60 * 60 # set expire to user specified or one minute
  end

  def redis(options = {})
    @redis_instance ||= Redis.new(options)
  end
end
