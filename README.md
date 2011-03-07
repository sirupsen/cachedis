# Cachedis

Cachedis caches your expensive queries to a Redis instance so the next time you fire it off, it'll load directly from cache instead of being run again. Optionally you can provide a cache expirement time.

    @cachedis = Cachedis.new

    # performs query the first time, performs cached calls to Redis within the next 60 * 60 seconds
    @cachedis.cachedis 'name-of-expensive-query', :expire => 60 * 60  do
      Post.all.expensive_operation
    end

## Installation and dependencies

Dependencies are: `redis-rb`

Install with: `gem install cachedis`

## Wishlist/To do/To consider

* ActiveRecord integration
    - `Post.all.expensive_operation.cachedis`
* Make expirement time optional
* Best serializing?
* Sexify the API
    - Make it easier to specialize expirement time (e.g. `:expire => 4.hours`), or just let this be for ActiveSupport users only?
