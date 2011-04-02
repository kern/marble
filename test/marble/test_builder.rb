require 'test_helper'

class TestBuilder < MiniTest::Unit::TestCase
  def setup
    @builder = Marble::Builder.new
  end
  
  def test_build
    hash = @builder.build do |m|
      m.hash do
        m.foo 'foo'
        
        m.bar :array do
          m.item 'bar'
        end
        
        m.baz :hash do
          m.baz 'baz'
        end
      end
    end
    
    assert_equal 'foo', hash['foo']
    assert_equal ['bar'], hash['bar']
    assert_equal({ 'baz' => 'baz' }, hash['baz'])
  end
  
  def test_empty_build
    assert_nil @builder.build
    
    @builder.build do |m|
      assert_same @builder, m
    end
  end
  
  def test_empty_array
    assert_equal [], @builder.array
    
    @builder.array do |m|
      assert_same @builder, m
    end
  end
  
  def test_empty_hash
    assert_equal({}, @builder.hash)
    
    @builder.hash do |m|
      assert_same @builder, m
    end
  end
  
  def test_item
    array = @builder.array do |m|
      m.item :array do
        m.item 'bar'
      end
    end
    
    assert_equal [['bar']], array
    
    array = @builder.array do |m|
      m.item do
        'bar'
      end
    end
    
    assert_equal ['bar'], array
    
    array = @builder.array do |m|
      m.item 'bar'
    end
    
    assert_equal ['bar'], array
  end
  
  def test_pair
    hash = @builder.hash do |m|
      m.pair 'foo', :hash do
        m.pair 'bar', 'baz'
      end
    end
    
    assert_equal({ 'bar' => 'baz' }, hash['foo'])
    
    hash = @builder.hash do |m|
      m.pair 'foo' do
        'bar'
      end
    end
    
    assert_equal({ 'foo' => 'bar' }, hash)
    
    hash = @builder.hash do |m|
      m.pair 'foo', 'bar'
    end
    
    assert_equal({ 'foo' => 'bar' }, hash)
  end
  
  def test_method_missing_in_array_context
    array = @builder.array do |m|
      m.foo :array do
        m.bar 'baz'
      end
    end
    
    assert_equal [['baz']], array
  end
  
  def test_method_missing_in_hash_context
    hash = @builder.hash do |m|
      m.foo :hash do
        m.bar 'baz'
      end
    end
    
    assert_equal({ 'bar' => 'baz' }, hash['foo'])
  end
  
  def test_method_missing_in_value_context
    assert_raises NoMethodError do
      @builder.build do |m|
        m.bar
      end
    end
  end
end