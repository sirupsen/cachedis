require 'redis'

module Cachedis
  Serializer = "Marshal"
  Options = {}
  QueryOptions = {}

  class Cacher
    attr_reader :redis_instance

    def initialize(options = {})
      redis(options)
    end

    def cachedis(key, options = {}, &block)
      result = yield
      
      return Kernel.const_get(Cachedis::Serializer).load(redis.get(key)) if redis.exists key

      result = Kernel.const_get(Cachedis::Serializer).dump(result)
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

  module Interface
    def self.cachedis(name, options = {}, &block)
      cachedis = Cacher.new(Cachedis::Options)
      
      cachedis.cachedis(name, Cachedis::QueryOptions.merge(options), &block)
    end
  end
end
