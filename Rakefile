require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/marble/test_*.rb'
end

task :all_tests => :test do
  sh <<-CMD
    cd test/rails3
    rake
  CMD
end