class Marble
  module Rails
    # Rails plugin for using Marble as a template handler.
    # 
    # Use the +marble+ variable to build a template. If you'd like to rename
    # the +marble+ variable (for example, to +m+), just use a parameter:
    # 
    #     marble.hash do |m|
    #       m.zombies 'run!'
    #     end
    # 
    # Marble is able to generate object literal, JSON, and YAML formats from
    # any Marble template. The naming schemes are as follows:
    # 
    # * Object literal: +view_name.to_s.marble+
    # * JSON: +view_name.json.marble+
    # * YAML: +view_name.yaml.marble+
    class TemplateHandler
      class_attribute :default_format
      self.default_format = Mime::JSON
      
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