# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'juman_knp/version'

Gem::Specification.new do |spec|
  spec.name          = "juman_knp"
  spec.version       = JumanKnp::VERSION
  spec.authors       = ["rilmayer"]
  spec.email         = ["git@frsw.net"]
  spec.summary       = %q{wrapper of JUMAN and KNP.}
  spec.description   = %q{You can use JUMAN and KNP for natural language processing, by Ruby.}
  spec.homepage      = "http://frsw.net/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
