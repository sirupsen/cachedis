require 'test_helper'

class CachedisTest < MiniTest::Unit::TestCase
  def setup
    @cachedis = Cachedis.new
    @cachedis.adapter = Cachedis::RedisAdapter.new(port: 16379)
  end

  def teardown
    @cachedis.adapter.flush
  end

  def test_cache_evaluates_block_on_first_try
    result = @cachedis.cache(:key) do
      "narwhals and ponies" 
    end

    assert_equal "narwhals and ponies", result
  end

  def test_sets_in_adapter_on_first_try
    @cachedis.adapter.expects(:set).with(:key, "narwhals and ponies", instance_of(Hash))

    @cachedis.cache(:key) do
      "narwhals and ponies" 
    end
  end

  def test_retries_from_cache_on_second_try
    @cachedis.cache(:key) do
      "narwhals and ponies" 
    end

    result = @cachedis.cache(:key) { "narwhals and ponies" }
    assert_equal "narwhals and ponies", result
  end

  def test_set_custom_expirement
    @cachedis.cache(:key, expire_in: 1) do
      "narwhals and ponies" 
    end

    sleep 1.0

    result = @cachedis.cache(:key) do
      "something else" 
    end

    assert_equal "something else", result
  end

  def test_set_expire_at
    @cachedis.cache(:key, expire_at: Time.now.to_i + 2) do
      "narwhals and ponies" 
    end

    sleep 2.0

    result = @cachedis.cache(:key) do
      "something else" 
    end

    assert_equal "something else", result
  end
end
