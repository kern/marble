module Marble
  class HashContext < Context
    def initialize
      @value = {}
      super
    end
    
    def key(key, value_or_context = nil)
      if block_given?
        @value[key] = self.class.context_for(value_or_context).run(&Proc.new)
      else
        @value[key] = value_or_context
      end
    end
    
    def method_missing(method, *args)
      if block_given?
        key(method, *args, &Proc.new)
      else
        key(method, *args)
      end
    end
  end
end