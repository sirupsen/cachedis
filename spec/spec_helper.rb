$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'cachedis'
require 'rspec'

module HelperMethods
  def with_no_cache
    @cachedis.redis_instance.should_receive(:exists).exactly(1).times.and_return(nil)
  end

  def with_cache(cache)
    @cachedis.redis_instance.should_receive(:exists).exactly(1).times.and_return(true)
    @cachedis.redis_instance.should_receive(:get).exactly(1).times.and_return(cache.to_yaml)
  end
end
