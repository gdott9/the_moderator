# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_moderator/version'

Gem::Specification.new do |spec|
  spec.name          = "the_moderator"
  spec.version       = TheModerator::VERSION
  spec.authors       = ["Guillaume DOTT"]
  spec.email         = ["guillaume.dott@lafourmi-immo.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "AGPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", "~> 3.2.0"
  spec.add_dependency "activerecord", "~> 3.2.0"
  spec.add_dependency "activesupport", "~> 3.2.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec", "~> 2.14.0"
  spec.add_development_dependency "combustion", "~> 0.5.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry"
end
