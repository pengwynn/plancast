$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "bundler/version"
require "shoulda/tasks"

require "rake/testtask"
Rake::TestTask.new(:test) do |test|
  test.ruby_opts = ["-rubygems"] if defined? Gem
  test.libs << "lib" << "test"
  test.pattern = "test/**/*_test.rb"
end
 
task :build do
  system "gem build plancast.gemspec"
end
 
task :release => :build do
  system "gem push plancast-#{Plancast::VERSION}.gem"
end

task :default => :test