require 'bundler'
require 'bundler/version'
require 'lib/plancast'

Gem::Specification.new do |s|
  s.name = %q{plancast}
  s.version = Plancast::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_rubygems_version = ">= 1.3.6"
  s.authors = ["Wynn Netherland"]
  s.date = %q{2010-05-22}
  s.description = %q{Wrapper for the Plancast API}
  s.email = %q{wynn.netherland@gmail.com}
  s.files = Dir.glob("{lib}/**/*")
  s.homepage = %q{http://github.com/pengwynn/plancast}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Wrapper for the Plancast API}
  s.test_files = [
    "test/helper.rb",
     "test/plancast_test.rb"
  ]

  s.add_bundler_dependencies
end

