require 'spec_helper'

describe Marble::HashContext do
  context 'when created' do
    it 'should be an empty hash' do
      Marble::HashContext.run do
      end.should == {}
    end
  end
  
  describe '#key' do
    context 'when called with a block' do
      it 'should set the key to the value of the block' do
        Marble::HashContext.run do
          key 'foo' do
            :foo
          end
          
          key 'bar' do
            'bar'
          end
        end.should == { 'foo' => :foo, 'bar' => 'bar' }
      end
    end
    
    context 'when called with a second argument and no block' do
      it 'should set the key to the second argument' do
        Marble::HashContext.run do
          key 'foo', :foo
          key 'bar', 'bar'
        end.should == { 'foo' => :foo, 'bar' => 'bar' }
      end
    end
    
    context 'when called without a second argument or block' do
      it 'should set the key to nil' do
        Marble::HashContext.run do
          key 'foo'
        end.should == { 'foo' => nil }
      end
    end
  end
  
  describe '#method_missing' do
    it 'should call #key with the method name as the key' do
      Marble::HashContext.run do
        foo
        bar 'bar'
        baz { 'baz' }
        qux :array do
          item 'qux'
        end
      end.should == { :foo => nil, :bar => 'bar', :baz => 'baz', :qux => ['qux'] }
    end
  end
end