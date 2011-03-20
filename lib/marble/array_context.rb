module Marble
  class ArrayContext < Context
    def initialize
      @value = []
      super
    end
    
    def item(value_or_context = nil)
      if block_given?
        @value.push self.class.context_for(value_or_context).run(&Proc.new)
      else
        @value.push value_or_context
      end
    end
  end
end