require 'spec_helper'

describe Marble::Builder do
  before do
    @builder = Marble::Builder.new do
      hash do
        foo 'foo'
        bar :array do
          item 'bar'
        end
        baz :hash do
          baz 'baz'
        end
      end
    end
  end
  
  describe 'when created without a block' do
    before do
      @builder = Marble::Builder.new
    end
    
    it 'should build nil' do
      @builder.build.should be_nil
    end
  end
  
  describe 'when created with a block' do
    it 'should build nil' do
      @builder.build.should == {
        :foo => 'foo',
        :bar => ['bar'],
        :baz => { :baz => 'baz' }
      }
    end
  end
  
  describe '#to_json' do
    it 'should convert the build result to JSON' do
      @builder.to_json.should == "{\"foo\":\"foo\",\"bar\":[\"bar\"],\"baz\":{\"baz\":\"baz\"}}"
    end
  end
  
  describe '#to_s' do
    it 'should convert the build result to a string' do
      @builder.to_s.should == "{:foo=>\"foo\", :bar=>[\"bar\"], :baz=>{:baz=>\"baz\"}}"
    end
  end
end