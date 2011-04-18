# Builder for Ruby objects. Provides a convenient interface for generating
# complex arrays and hashes.
# 
# First instantiate a builder:
# 
#     builder = Marble.new
# 
# Then, call either `#build`, `#array`, or `#hash` on the builder. You can use
# the yielded block parameter to give the builder a shorter name. I suggest `m`.
# 
#     builder.hash do |m|
#       m.zombies 'oh my!'
#     end
# 
# The returned value is the built object.
class Marble
  # Builds an arbitrary value.
  # 
  # @example Build a simple value
  #     builder = Marble.new
  #     builder.build do |m|
  #       true
  #     end # => true
  # 
  # @example Build a more complex value
  #     builder = Marble.new
  #     builder.build do |m|
  #       m.array do
  #         m.item 'foo'
  #       end
  #     end # => ['foo']
  # 
  # @yield [builder] block to evaluate for the value
  # @yieldparam builder [Marble] the current builder
  # @yieldreturn [Object] the built value
  def build(&block)
    value_structure(&block)
  end
  
  # Builds a hash.
  # 
  # @example Build a simple hash
  #     builder = Marble.new
  #     builder.hash do |m|
  #       m.foo 'bar'
  #       m.baz 'quz'
  #     end # => { 'foo' => 'bar', 'baz' => 'quz' }
  # 
  # @example Build nested hashes
  #     builder = Marble.new
  #     builder.hash do |m|
  #       m.foo :hash do
  #         m.bar 'baz'
  #       end
  #     end # => { 'foo' => { 'bar' => 'baz' } }
  # 
  # @yield [builder] block to evaluate within the hash's context
  # @yieldparam builder [Marble] the current builder
  # @yieldreturn [Object] the built hash
  def hash(&block)
    insert_structure({}, &block)
  end
  
  # Builds an array.
  # 
  # @example Build a simple array
  #     builder = Marble.new
  #     builder.array do |m|
  #       m.item 'foo'
  #       m.item 'bar'
  #     end # => ['foo', 'bar']
  # 
  # @example Build nested arrays
  #     builder = Marble.new
  #     builder.array do |m|
  #       m.item :array do
  #         m.item 'foo'
  #       end
  #     end # => [['foo']]
  # 
  # @yield [builder] block to evaluate within the array's context
  # @yieldparam builder [Marble] the current builder
  # @yieldreturn [Object] the built array
  def array(&block)
    insert_structure([], &block)
  end
  
  # Calls `#pair` or `#key` depending on the context.
  # 
  # When the current structure responds to `#push` (for example, in an array
  # context), it calls `#item` ignoring the method name. This allows you to be
  # more semantic when defining the items in an array. However, in most cases
  # calling `#item` will suffice.
  # 
  # When the current structure responds to `#[]=` (for example, in a hash
  # context), it calls `#pair` with the stringified method name as the key.
  # This, in general, is a more concise and preferred way than explicitly
  # calling `#pair`.
  # 
  # @example Build an array
  #     builder = Marble.new
  #     builder.array do |m|
  #       m.milk 'toast'
  #     end # => ['foo', 'bar']
  # 
  # @example Build a hash
  #     builder = Marble.new
  #     builder.hash do |m|
  #       m.milk 'toast'
  #     end # => { 'milk' => 'toast' }
  def method_missing(method, *args, &block)
    if @current.respond_to?(:push)
      item(*args, &block)
    elsif @current.respond_to?(:[]=)
      pair(method.to_s, *args, &block)
    else
      super
    end
  end
  
  # Inserts an item into the current structure.
  # 
  # Arrays are the most common structure into which you insert an item (any
  # value). Items are inserted using `#push`, so if you'd like to duck-type an
  # array for whatever reason, go ahead.
  # 
  # You can provide values using either the second parameter or a block. If you
  # provide a block, the block will be evaluated immediately.
  # 
  # Blocks by default insert the value of the block into the item. However, you
  # can optionally specify the structure type of the block as either `:array` or
  # `:hash` to insert an array or hash structure. That means that these are all
  # equivalent:
  # 
  #     m.array do
  #       m.item ['value']
  #     end
  #     
  #     m.array do
  #       m.item do
  #         ['value']
  #       end
  #     end
  #     
  #     m.array do
  #       m.item :hash do
  #         m.pair 'key', 'value'
  #       end
  #     end
  # 
  # Choose the format that makes the most sense in a given context.
  # 
  # @overload item(value)
  #   @param value [Object] the value to insert into the item
  # @overload item()
  #   @yield [builder] block to evaluate for the item's value
  #   @yieldparam builder [Marble] the current builder
  #   @yieldreturn [Object] the value to insert into the item
  # @overload item(structure_type)
  #   @param structure_type [:array, :hash] the block's structure type
  #   @yield [builder] block to evaluate for the item's value
  #   @yieldparam builder [Marble] the current builder
  #   @yieldreturn [Object] the value to insert into the item
  def item(value_or_structure_type = nil, &block)
    if block_given?
      @current.push evaluate_structure(value_or_structure_type, &block)
    else
      @current.push value_or_structure_type
    end
  end
  
  # Inserts a pair into the current structure.
  # 
  # Hashes are the most common structure into which you insert a pair (key and
  # value). Pairs are inserted using `#[]=`, so if you'd like to duck-type a
  # hash for whatever reason, go ahead.
  # 
  # You can provide values using either the second parameter or a block. If you
  # provide a block, the block will be evaluated immediately.
  # 
  # Blocks by default insert the value of the block into the pair. However, you
  # can optionally specify the structure type of the block as either `:array` or
  # `:hash` to insert an array or hash structure. That means that these are all
  # equivalent:
  # 
  #     m.hash do
  #       m.pair 'key', ['value']
  #     end
  #     
  #     m.hash do
  #       m.pair 'key' do
  #         ['value']
  #       end
  #     end
  #     
  #     m.hash do
  #       m.pair 'key', :array do
  #         m.item 'value'
  #       end
  #     end
  # 
  # Choose the format that makes the most sense in a given context.
  # 
  # @overload pair(key, value)
  #   @param key [Object] the key to use for the pair
  #   @param value [Object] the value to insert into the pair
  # @overload pair(key)
  #   @param key [Object] the key to use for the pair
  #   @yield [builder] block to evaluate for the pair's value
  #   @yieldparam builder [Marble] the current builder
  #   @yieldreturn [Object] the value to insert into the pair
  # @overload pair(key, structure_type)
  #   @param key [Object] the key to use for the pair
  #   @param structure_type [:array, :hash] the block's structure type
  #   @yield [builder] block to evaluate for the pair's value
  #   @yieldparam builder [Marble] the current builder
  #   @yieldreturn [Object] the value to insert into the pair
  def pair(key, value_or_structure_type = nil, &block)
    if block_given?
      @current[key] = evaluate_structure(value_or_structure_type, &block)
    else
      @current[key] = value_or_structure_type
    end
  end
  
  private
  
  # Inserts a value structure.
  # 
  # This is really only used as an easy way to insert into the current structure
  # to whatever the block evaluates.
  # 
  # @yield [builder] block to evaluate for the value
  # @yieldparam builder [Marble] the current builder
  # @yieldreturn [Object] the built value
  def value_structure(&block)
    insert_structure(nil, &block)
  end
  
  # Inserts a structure into the current structure.
  # 
  # @param structure [Object] the new structure to insert
  # @yield [builder] block to evaluate for the value
  # @yieldparam builder [Marble] the current builder
  # @yieldreturn [Object] the built value
  def insert_structure(structure)
    if block_given?
      parent = @current
      @current = structure
      value = yield(self)
      @current = parent
    end
    
    structure || value
  end
  
  # Convenience method for inserting the correct structure type based on a
  # symbol.
  # 
  # @param type [Symbol] the structure type
  # @yield [builder] block to evaluate for the value
  # @yieldparam builder [Marble] the current builder
  # @yieldreturn [Object] the built value
  def evaluate_structure(type, &block)
    case type
    when :hash then hash(&block)
    when :array then array(&block)
    else value_structure(&block)
    end
  end
end

require 'marble/version'

if defined? ActionView::Template
  require 'marble/rails'
end