require 'spec_helper'

describe CachedisInterface do
  include HelperMethods

  describe 'when setting something' do
    it 'sets without errors' do
      @mock = mock(Cachedis)
      Cachedis.should_receive(:new).exactly(1).times.and_return(@mock)
      @mock.stub!(:cachedis).and_return(['element', 'element 2'])
      
      CachedisInterface.cachedis 'expensive-query' do
        ['element', 'element 2']
      end
    end
  end
end
