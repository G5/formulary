# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formulary/version'

Gem::Specification.new do |spec|
  spec.name          = "formulary"
  spec.version       = Formulary::VERSION
  spec.authors       = ["Matt Bohme", "Don Petersen"]
  spec.email         = ["matt.bohme@g5searchmarketing.com", "don.petersen@g5searchmarketing.com"]
  spec.description   = %q{Valid form submission based on the HTML5 validation on the form itself}
  spec.summary       = %q{Valid form submission based on the HTML5 validation on the form itself}
  spec.homepage      = "http://github.com/g5/formulary"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "active_support"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
