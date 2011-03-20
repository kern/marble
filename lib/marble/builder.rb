module Marble
  class Builder
    def build
      block_given? ? value_structure { yield(self) } : nil
    end
    
    def hash
      insert_structure({}) do
        yield self if block_given?
      end
    end
    
    def array
      insert_structure([]) do
        yield self if block_given?
      end
    end
    
    def method_missing(method, *args)
      if block_given?
        case args[0]
        when :hash then write(method) { hash { yield(self) } }
        when :array then write(method) { array { yield(self) } }
        else write(method) { value_structure { yield(self) } }
        end
      else
        write(method, args[0])
      end
    end
    
    def write(key, value = nil)
      value = value_structure { yield(self) } if block_given?
      
      case @current
      when Hash then @current[key.to_s] = value
      when Array then @current.push(value)
      end
    end
    
    protected
    
    def value_structure
      insert_structure(nil) do
        yield self if block_given?
      end
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
  end
end