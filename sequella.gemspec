# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sequella/version"

Gem::Specification.new do |s|
  s.name        = "sequella"
  s.version     = Sequella::VERSION
  s.authors     = ["Ben Klang"]
  s.email       = ["bklang@mojolingo.com"]
  s.homepage    = ""
  s.summary     = %q{Sequel ORM plugin for Adhearsion}
  s.description = %q{This gem provides a plugin for Adhearsion, allowing you to create and use Sequel ORM-based models in your Adhearsion application.}

  s.rubyforge_project = "sequella"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency %q<adhearsion>, ["~> 2.1"]
  s.add_runtime_dependency %q<sequel>, [">= 3.40.0"]

  s.add_development_dependency %q<bundler>, ["~> 1.0"]
  s.add_development_dependency %q<rspec>, ["~> 2.5"]
  s.add_development_dependency %q<rake>, [">= 0"]
  s.add_development_dependency %q<mocha>, [">= 0"]
  s.add_development_dependency %q<guard-rspec>
  s.add_development_dependency %q<simplecov>
  s.add_development_dependency %q<simplecov-rcov>
 end
