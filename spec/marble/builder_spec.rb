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
      
      it 'shoud return the value of the block' do
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
  
  describe '#write' do
    context 'when #current is nil' do
      it 'should silently be ignored' do
        @builder.build do |m|
          m.write 'test', 'lol'
        end.should be_nil
      end
    end
    
    context 'when #current is a hash' do
      context 'when called with a block' do
        it 'should add the value of the block to #current with the key as the method name' do
          @builder.hash do |m|
            m.write 'foo' do
              'bar'
            end
          end.should == { 'foo' => 'bar' }
        end
      end
      
      context 'when called without a block' do
        it 'should add value to #current with the key as the method name' do
          @builder.hash do |m|
            m.write 'foo', 'bar'
          end.should == { 'foo' => 'bar' }
        end
      end
    end
    
    context 'when #current is an array' do
      context 'when called with a block' do
        it 'should push the value of the block to #current' do
          @builder.array do |m|
            m.foo do
              'bar'
            end
          end.should == ['bar']
        end
      end
      
      context 'when called without a block' do
        it 'should push the argument to #current' do
          @builder.array do |m|
            m.foo 'bar'
          end.should == ['bar']
        end
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
    context 'when called with :hash' do
      it 'should be equivalent to nesting #hash within the block' do
        @builder.array do |m|
          m.foo :hash do
            m.bar 'baz'
          end
        end.should == [{ 'bar' => 'baz' }]
      end
    end
    
    context 'when called with :array' do
      it 'should be equivalent to nesting #array within the block' do
        @builder.array do |m|
          m.foo :array do
            m.item 'bar'
            m.item 'baz'
          end
        end.should == [['bar', 'baz']]
      end
    end
    
    context 'when called with anything else' do
      it 'should call #write' do
        @builder.array do |m|
          m.foo [] do
            m.ignore_me 'lolololol'
            'baz'
          end
          
          m.foo {}
        end.should == ['baz', nil]
      end
    end
  end
end