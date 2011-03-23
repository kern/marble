require 'spec_helper'

describe Marble::Builder do
  before do
    @builder = Marble::Builder.new
  end
  
  describe '#build' do
    context 'when called without a block' do
      it 'should build nil' do
        @builder.build.should be_nil
      end
    end
    
    context 'when called with a block' do
      it 'should yield itself' do
        @builder.build do |m|
          m.should == @builder
        end
      end
      
      it 'should return the value of the block' do
        @builder.build do |m|
          m.hash do
            m.foo 'foo'
            
            m.bar :array do
              m.item 'bar'
            end
            
            m.baz :hash do
              m.baz 'baz'
            end
          end
        end.should == {
          'foo' => 'foo',
          'bar' => ['bar'],
          'baz' => { 'baz' => 'baz' }
        }
      end
    end
  end
  
  describe '#item' do
    context 'when called with a block' do
      context 'when called with a structure type' do
        it 'should push the structure to #current' do
          @builder.array do |m|
            m.item :array do
              m.item 'bar'
            end
          end.should == [['bar']]
        end
      end
      
      context 'when called without a structure type' do
        it 'should push the value of the block to #current' do
          @builder.array do |m|
            m.item do
              'bar'
            end
          end.should == ['bar']
        end
      end
    end
    
    context 'when called without a block' do
      it 'should push the argument to #current' do
        @builder.array do |m|
          m.item 'bar'
        end.should == ['bar']
      end
    end
  end
  
  describe '#pair' do
    context 'when called with a block' do
      context 'when called with a structure type' do
        it 'should add the value of the block to #current with the key as the method name' do
          @builder.hash do |m|
            m.pair 'foo', :hash do
              m.pair 'bar', 'baz'
            end
          end.should == { 'foo' => { 'bar' => 'baz' } }
        end
      end
      
      context 'when called without a structure type' do
        it 'should add the value of the block to #current with the key as the method name' do
          @builder.hash do |m|
            m.pair 'foo' do
              'bar'
            end
          end.should == { 'foo' => 'bar' }
        end
      end
    end
    
    context 'when called without a block' do
      it 'should add value to #current with the key as the method name' do
        @builder.hash do |m|
          m.pair 'foo', 'bar'
        end.should == { 'foo' => 'bar' }
      end
    end
  end
  
  describe '#hash' do
    it 'should return an empty hash by default' do
      @builder.hash.should == {}
    end
    
    it 'should yield the builder' do
      @builder.hash do |m|
        m.should == @builder
      end
    end
  end
  
  describe '#array' do
    it 'should return an empty array by default' do
      @builder.array.should == []
    end
    
    it 'should yield the builder' do
      @builder.array do |m|
        m.should == @builder
      end
    end
  end
  
  describe '#method_missing' do
    context 'when called in a context that responds to #push' do
      it 'should proxy to #item' do
        @builder.array do |m|
          m.foo :array do
            m.bar 'baz'
          end
        end.should == [['baz']]
      end
    end
    
    context 'when called in a context that responds to #[]= but not #push' do
      it 'should proxy to #pair' do
        @builder.hash do |m|
          m.foo :hash do
            m.bar 'baz'
          end
        end.should == { 'foo' => { 'bar' => 'baz' } }
      end
    end
    
    context 'when called in any other context' do
      it 'should raise NoMethodError' do
        expect {
          @builder.build do |m|
            m.bar
          end
        }.to raise_error(NoMethodError)
      end
    end
  end
end