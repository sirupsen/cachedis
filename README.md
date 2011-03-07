# Cachedis

Cachedis caches your expensive queries to a Redis instance so the next time you fire it off, it'll load directly from cache instead of being run again. Optionally you can provide a cache expirement time.

    @cachedis = Cachedis.new

    # performs query the first time, performs cached calls to Redis within the next 60 * 60 seconds
    @cachedis.cachedis 'name-of-expensive-query', :expire => 60 * 60  do
      Post.all.expensive_operation
    end

## Wishlist

* Tight ActiveRecord integration
* Make expirement optional
* Serialize using BERT (fall back to YAML)
* Sexify the API
    - Make it easier to specialize expirement time (e.g. `:expire => 4.hours`)
