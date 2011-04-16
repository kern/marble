ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'rails/test_help'
require 'mocha'

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }