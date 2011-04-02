# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'marble/version'

Gem::Specification.new do |s|
  s.name        = 'marble'
  s.version     = Marble::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alexander Kern']
  s.email       = ['alex@kernul.com']
  s.homepage    = 'https://github.com/CapnKernul/marble'
  s.summary     = %q{Ruby object literal builder}
  s.description = %q{DSL for creating complex Ruby hashes and arrays}
  
  s.rubyforge_project = 'marble'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_development_dependency 'minitest', '~> 2.0'
  s.add_development_dependency 'mocha', '~> 0.9'
  s.add_development_dependency 'autotest', '~> 4.4'
  s.add_development_dependency 'rails', '3.0.5'
end