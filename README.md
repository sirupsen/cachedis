# Cachedis

Cachedis caches your expensive queries to a Redis instance so the next time you fire it off, it'll load directly from cache instead of being run again. 

    cachedis 'expensive:query', :expire => 60 * 60  do
      Post.all.expensive_operation
    end

## Documentation

`cachedis` takes two arguments in addition to a block which should return whatever you want `cachedis` to cache:

    key, options = {}

The key is the name of the key under which the objects are saved as in Redis. Options are send directly to the Redis instance in along. For instance the option could be expiring the key at a certain time:

    include Cachedis::Interface

    # expire in an hour using Redis' EXPIRE command
    cachedis 'users:all:with_avatars', :expire => 60 * 60 * 60 do
      User.all.with_avatars
    end

    # expire at unix timestamp with Redis' EXPIREAT command
    cachedis 'expensive:query', :expireat => Time.new(2012,2,2).to_i do
      # insert expensive query here
    end

### Configuration

If you want to configure the server(s) or port(s) for `cachedis` to use, you should override the default `Cachedis::Interface#cachedis` method. Whatever you pass to `#new` is passed directly to the instance of the Redis object from the [redis-rb][rr] library:

    def cachedis(name, options = {}, &block)
      @cachedis ||= Cachedis.new(:host => "10.0.1.1", :port => 6380)
      @cachedis.cachedis(name, options, &block)
    end

## Installation and dependencies

Dependencies: [redis-rb][rr]

Install: `gem install cachedis`

[Redis](http://redis.io) should be running in the background, start it with `redis-server`.

## Serialization

I experimented and benchmarked with `JSON`, `YAML` and `Marshal` using the drivers in the Ruby standard libary with [this script](https://gist.github.com/858604).

Marshal is about 2x as fast as the other formats. However, it's also the one that is gonna take up the most space, but it's so little that it should not matter.

You can switch serialization driver if you need to by overriding `Cachedis.serializer`. The serializer must respond to `#load` and `#dump`, remember to require it before using it with `cachedis`:

    module Cachedis
      def self.serializer
        "YAML"
      end
    end

## Wishlist/To do/To consider

* ActiveRecord integration
    - `Post.all.expensive_operation.cachedis`
* Make expirement time optional
* Sexify the API
    - Make it easier to specialize expirement time (e.g. `:expire => 4.hours`), or just let this be for ActiveSupport users only?
* Rename `Cachedis#cachedis`?

[rr]: https://github.com/ezmobius/redis-rb
