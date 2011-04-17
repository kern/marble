class Marble
  def build(&block)
    value_structure(&block)
  end
  
  def hash(&block)
    insert_structure({}, &block)
  end
  
  def array(&block)
    insert_structure([], &block)
  end
  
  def method_missing(method, *args, &block)
    if @current.respond_to?(:push)
      item(*args, &block)
    elsif @current.respond_to?(:[]=)
      pair(method.to_s, *args, &block)
    else
      super
    end
  end
  
  def item(value_or_structure_type = nil, &block)
    if block_given?
      @current.push evaluate_structure(value_or_structure_type, &block)
    else
      @current.push value_or_structure_type
    end
  end
  
  def pair(key, value_or_structure_type = nil, &block)
    if block_given?
      @current[key] = evaluate_structure(value_or_structure_type, &block)
    else
      @current[key] = value_or_structure_type
    end
  end
  
  private
  
  def value_structure(&block)
    insert_structure(nil, &block)
  end
  
  def insert_structure(structure)
    if block_given?
      parent = @current
      @current = structure
      value = yield(self)
      @current = parent
    end
    
    structure || value
  end
  
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