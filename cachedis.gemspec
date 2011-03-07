# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cachedis/version"

Gem::Specification.new do |s|
  s.name        = "cachedis"
  s.version     = Cachedis::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Hørup Eskildsen"]
  s.email       = ["sirup@sirupsen.com"]
  s.homepage    = ""
  s.summary     = %q{Caches expensive database queries in Redis}
  s.description = %q{Instead of running your expensive queries for every page load, let cachedis store them in Redis and fetch them.}

  s.rubyforge_project = "cachedis"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Dependencies
  s.add_dependency('redis')

  # Development dependencies
  s.add_development_dependency('rspec')
  s.add_development_dependency('fuubar')
end
