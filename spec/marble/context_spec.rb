require 'spec_helper'

describe Marble::Context do
  context 'when created without a block' do
    it 'should have a value of nil' do
      Marble::Context.new.value.should be_nil
    end
  end
  
  context 'when created with a block' do
    it 'should #instance_eval the block' do
      Marble::Context.new do
        @value = 'test'
      end.value.should == 'test'
    end
  end
  
  describe '.run' do
    it 'should create a new Context and return the value of it' do
      Marble::Context.run do
        @value = 'yuh-huh'
      end.should == 'yuh-huh'
    end
  end
  
  describe '.context_for' do
    it 'should be ArrayContext for :array' do
      Marble::Context.context_for(:array).should == Marble::ArrayContext
    end
    
    it 'should be HashContext for :hash' do
      Marble::Context.context_for(:hash).should == Marble::HashContext
    end
    
    it 'should be ValueContext for anything else' do
      [nil, :value, 'lol'].each do |c|
        Marble::Context.context_for(c).should == Marble::ValueContext
      end
    end
  end
end