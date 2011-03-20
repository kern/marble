module Marble
  module Rails
    class TemplateHandler
      class_attribute :default_format
      self.default_format = Mime::JSON
      
      def call(template)
        compiled = "builder = Marble::Builder.new;" +
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