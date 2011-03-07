require 'spec_helper'

describe Cachedis do
  include HelperMethods

  before do
    @cachedis = Cachedis.new
  end

  describe 'when setting something' do
    it 'sets without errors' do
      with_no_cache
      @cachedis.redis_instance.should_receive(:set).exactly(1).times.and_return(['element', 'element 2'].to_yaml)
      
      lambda { 
      @cachedis.cachedis 'expensive-query' do
        ['element', 'element 2']
      end }.should_not raise_error
    end
  end

  describe 'when setting and later retrieving something' do
    it 'retrieves from redis cache' do
      with_cache('query')
      @cachedis.redis_instance.should_not_receive(:set)

      result = @cachedis.cachedis 'expensive-query' do
                "query"
              end

      result.should == "query".to_yaml
    end
  end
end
