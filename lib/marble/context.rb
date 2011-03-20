module Marble
  class Context
    attr_reader :value
    
    def initialize
      run_block(&Proc.new) if block_given?
    end
    
    def self.run
      if block_given?
        new(&Proc.new).value
      else
        new.value
      end
    end
    
    def self.context_for(type)
      case type
      when :array then ArrayContext
      when :hash then HashContext
      else ValueContext
      end
    end
    
    protected
    
    def run_block
      instance_eval(&Proc.new) if block_given?
    end
  end
end