require 'spec_helper'

describe Marble::ValueContext do
  describe '.run' do
    it 'should return the value of the last statement' do
      Marble::ValueContext.run do
        1234
      end.should == 1234
    end
  end
  
  describe '#array' do
    it 'should create an ArrayContext and return the value of it' do
      Marble::ValueContext.run do
        array do
          item :foo
          item :bar
        end
      end.should == [:foo, :bar]
    end
  end
  
  describe '#hash' do
    it 'should create a HashContext and return the value of it' do
      Marble::ValueContext.run do
        hash do
          foo :bar
          bar :bar
        end
      end.should == { :foo => :bar, :bar => :bar }
    end
  end
end