require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/marble/**/*_spec.rb'
end

task :all_specs => :spec do
  sh <<-CMD
    cd spec/rails3
    bundle exec rake
  CMD
end