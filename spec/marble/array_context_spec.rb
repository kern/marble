require 'spec_helper'

describe Marble::ArrayContext do
  context 'when created' do
    it 'should be an empty array' do
      Marble::ArrayContext.run do
      end.should == []
    end
  end
  
  describe '#item' do
    context 'when called with a block' do
      context 'when there is no argument' do
        it 'should push the value of the block to the value' do
          Marble::ArrayContext.run do
            item { :foo }
            item { 'foo' }
            item do
              hash do
                aaa 'lol'
              end
            end
          end.should == [:foo, 'foo', { :aaa => 'lol' }]
        end
      end
      
      context 'when the argument is :array' do
        it 'should yield an ArrayContext and push the value of the context' do
          Marble::ArrayContext.run do
            item :array do
              item :foo
              item :bar
            end
          end.should == [[:foo, :bar]]
        end
      end
      
      context 'when the argument is :hash' do
        it 'should yield an HashContext and push the value of the context' do
          Marble::ArrayContext.run do
            item :hash do
              foo 'test'
              bar 'test'
            end
          end.should == [{ :foo => 'test', :bar => 'test'}]
        end
      end
    end
    
    context 'when called with an argument and no block' do
      it 'should push the argument to the value' do
        Marble::ArrayContext.run do
          item 'test'
          item []
        end.should == ['test', []]
      end
    end
    
    context 'when called without an argument or block' do
      it 'should push nil to the value' do
        Marble::ArrayContext.run do
          item
        end.should == [nil]
      end
    end
  end
end