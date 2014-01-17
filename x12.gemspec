# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "x12/version"

Gem::Specification.new do |s|
  s.name        = "x12"
  s.version     = X12::VERSION
  s.authors     = ["Sean Walberg"]
  s.email       = ["sean@ertw.com"]
  s.homepage    = ""
  s.summary     = %q{A gem to handle parsing and generation of ANSI X12 documents}
  s.description = %q{A gem to handle parsing and generation of ANSI X12 documents. Forked from the project at http://www.appdesign.com/x12parser/}

  s.rubyforge_project = "x12"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'nokogiri'

  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_development_dependency('awesome_print')
  s.add_development_dependency('rake')
  s.add_development_dependency('byebug') if RUBY_VERSION =~ /^2/
end
