module Marble
  autoload :Builder, 'marble/builder'
end

require 'marble/version'

if defined? ActionView::Template
  require 'marble/rails'
end