require 'redis'

class Cachedis
  attr_accessor :adapter

  DEFAULT_OPTIONS = {
    expire_in: 3600
  }

  def cache(key, **options, &block)
    cached = adapter.get(key)
    return cached if cached

    result = yield
    adapter.set(key, result, fix_options(**options))
    result
  end

  private
  def fix_options(options)
    options = DEFAULT_OPTIONS.merge(options)

    if options[:expire_at]
      options[:expire_in] = options[:expire_at] - Time.now.to_i
    end

    options
  end

  class RedisAdapter
    attr_accessor :redis

    def initialize(port: 6380)
      @redis = Redis.new(port: port)
    end

    def set(key, value, options)
      @redis.setex(key, options[:expire_in].to_i, value)
    end

    def get(key)
      @redis.get(key)
    end
    
    def flush
      @redis.flushall
    end
  end
end
