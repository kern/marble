class Marble
  # Container for Rails-related Marble classes
  module Rails
    # Rails plugin for using Marble as a template handler.
    # 
    # Marble has three output formats: text, JSON, and YAML. The template
    # handler calls `to_s`, `to_json`, and `to_yaml` for each format,
    # respectively.
    # 
    # Marble sets up a builder for you; simply use the `marble` variable to
    # access the builder. To rename the builder to another, possibly shorter
    # variable in order to save keystrokes, put the new variable name as the
    # name of the block parameter:
    # 
    #     marble.hash do |m|
    #       m.free 'toast'
    #     end
    # 
    # Marble loads this module only if it can find `ActionView`.
    class TemplateHandler
      class_attribute :default_format
      self.default_format = Mime::JSON
      
      # Compile the Rails template.
      # 
      # @param template [Class] the Rails template class
      # @return [String] the compiled template
      def call(template)
        compiled = "builder = Marble.new;" +
                   "builder.build { |marble| #{template.source} }."
        
        if template.formats.include?(:yaml)
          compiled += 'to_yaml'
        elsif template.formats.include?(:json)
          compiled += 'to_json'
        else
          compiled += 'to_s'
        end
        
        compiled
      end
    end
  end
end

ActionView::Template.register_template_handler(:marble, Marble::Rails::TemplateHandler.new)