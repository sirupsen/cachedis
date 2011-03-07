$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'cachedis'
require 'rspec'

module HelperMethods
  def with_no_cache(cache = nil)
    @cachedis.redis.should_receive(:exists).exactly(1).times.and_return(false)
    @cachedis.redis.should_receive(:set).exactly(1).times.and_return(cache)
  end

  def with_cache(cache)
    @cachedis.redis.should_receive(:exists).exactly(1).times.and_return(true)
    @cachedis.redis.should_receive(:get).exactly(1).times.and_return(cache.to_yaml)
  end
end
