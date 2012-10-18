# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "springsense-ruby/version"

Gem::Specification.new do |s|
  s.name        = "springsense-ruby"
  s.version     = SpringSense::Ruby::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tal Rotbart"]
  s.email       = ["tal@springsense.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby bindings for the SpringSense API}
  s.description = %q{Ruby bindings for the SpringSense API. See http://springsense.com/api for more information}

  s.rubyforge_project = "springsense-ruby"

  s.add_dependency "json"
  s.add_dependency "mashape"
  s.add_dependency('activesupport', '>= 3.0.0')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
