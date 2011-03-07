# Cachedis

Cachedis caches your expensive queries to a Redis instance so the next time you fire it off, it'll load directly from cache instead of being run again. Optionally you can provide a cache expirement time.

    @cachedis = Cachedis.new

    # performs query the first time, performs cached calls to Redis within the next 60 * 60 seconds
    @cachedis.cachedis 'name-of-expensive-query', :expire => 60 * 60  do
      Post.all.expensive_operation
    end

## Documentation

The main method of `Cachedis` is `#cachedis`, it takes the following parameters:

    key, options = {}

The key is the name of the key the objects are saved as in Redis. Options are send directly to the Redis instance in addition to setting the key to the result of the query. For instance the option could be expiring the key at a certain time:

    # expire in an hour
    @cachedis.cachedis 'users:all:with_avatars', :expire => 60 * 60 * 60 do
      User.all.with_avatars
    end

    # expire at unix timestamp with Redis' EXPIREAT command
    @cachedis.cachedis 'expensive:query', :expireat => Time.new(2012,2,2).to_i do
      # insert expensive query here
    end

## Installation and dependencies

Dependencies: `redis-rb`

Install: `gem install cachedis`

[Redis](http://redis.io) should be running in the background, start it with `redis-server`.

## Wishlist/To do/To consider

* ActiveRecord integration
    - `Post.all.expensive_operation.cachedis`
* Make expirement time optional
* Best serializing?
* Sexify the API
    - Make it easier to specialize expirement time (e.g. `:expire => 4.hours`), or just let this be for ActiveSupport users only?
* Rename `Cachedis#cachedis`?
