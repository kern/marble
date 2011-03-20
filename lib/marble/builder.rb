require 'json'

module Marble
  class Builder
    def initialize
      @block = Proc.new if block_given?
    end
    
    def build
      if @block
        ValueContext.run(&@block)
      else
        nil
      end
    end
    
    def to_json
      build.to_json
    end
    
    def to_s
      build.to_s
    end
  end
end