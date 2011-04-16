require 'bundler'
Bundler::GemHelper.install_tasks

task :default => 'test:unit'

task :test => ['test:unit', 'test:rails']

require 'rake/testtask'
Rake::TestTask.new('test:unit') do |t|
  t.libs << 'test'
  t.pattern = 'test/marble/test_*.rb'
end

task 'test:rails' do
  sh <<-CMD
    cd test/rails3
    rake
  CMD
end