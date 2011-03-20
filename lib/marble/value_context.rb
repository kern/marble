module Marble
  class ValueContext < Context
    def array
      if block_given?
        ArrayContext.run(&Proc.new)
      else
        ArrayContext.run
      end
    end
    
    def hash
      if block_given?
        HashContext.run(&Proc.new)
      else
        HashContext.run
      end
    end
    
    protected
    
    def run_block
      @value = instance_eval(&Proc.new) if block_given?
    end
  end
end