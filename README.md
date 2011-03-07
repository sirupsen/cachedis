# Cachedis

Cachedis caches your expensive queries to a Redis instance so the next time you fire it off, it'll load directly from cache instead of being run again. 

    cachedis 'expensive:query', :expire => 60 * 60  do
      Post.all.expensive_operation
    end

## Documentation

You can specify two types of options via constants:

* `Cachedis::Options`
    - Passed directly to [redis-rb][rr]
    - Options like host options, port options, etc.
* `Cachedis::QueryOptions`
    - Default options for the `cachedis` queries
    - For instance if you always want queries to expire in an hour:
        - `CACHEDIS_DEFAULT_QUERY_OPTIONS = { :expire => 60 * 60 * 60}`
    - Overridden by options passed to `cachedis` directly

`cachedis` takes two arguments in addition to a block which should return whatever you want `cachedis` to cache:

    key, options = {}

The key is the name of the key under which the objects are saved as in Redis. Options are send directly to the Redis instance in along. For instance the option could be expiring the key at a certain time:

    include CachedisInterface

    # expire in an hour using Redis' EXPIRE command
    cachedis 'users:all:with_avatars', :expire => 60 * 60 * 60 do
      User.all.with_avatars
    end

    # expire at unix timestamp with Redis' EXPIREAT command
    cachedis 'expensive:query', :expireat => Time.new(2012,2,2).to_i do
      # insert expensive query here
    end

## Installation and dependencies

Dependencies: [redis-rb][rr]

Install: `gem install cachedis`

[Redis](http://redis.io) should be running in the background, start it with `redis-server`.

## Serialization

I experimented with `JSON`, `YAML` and `Marshal` using the drivers in the Ruby standard libary with [this script](https://gist.github.com/858604).

It shows that Marshal is about 2x as fast as the other formats. However, it's also the one that is gonna take up the most space, but it's so little that it should not matter. You can switch serialization driver if you need to by replacing `Cachedis::Driver`, be sure to require your serialization library first, and that it responds to `#dump` and `#load`.

## Wishlist/To do/To consider

* ActiveRecord integration
    - `Post.all.expensive_operation.cachedis`
* Make expirement time optional
* Best serializing?
* Sexify the API
    - Make it easier to specialize expirement time (e.g. `:expire => 4.hours`), or just let this be for ActiveSupport users only?
* Rename `Cachedis#cachedis`?

[rr]: https://github.com/ezmobius/redis-rb
