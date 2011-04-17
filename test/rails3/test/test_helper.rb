ENV['RAILS_ENV'] ||= 'test'

puts 'GOD!L:SKJDF:LSKJDF'

require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'rails/test_help'
require 'mocha'

puts 'fa8dysgf'

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }