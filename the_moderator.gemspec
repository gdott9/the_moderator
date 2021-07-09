# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_moderator/version'

Gem::Specification.new do |spec|
  spec.name          = "the_moderator"
  spec.version       = TheModerator::VERSION
  spec.authors       = ["Guillaume DOTT"]
  spec.email         = ["guillaume+github@dott.fr"]
  spec.description   = %q{Moderate fields of a model or its associations}
  spec.summary       = %q{Moderate fields before their insertion in the database by serializing and saving them into a separate 'moderations' table.}
  spec.homepage      = "https://github.com/gdott9/the_moderator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 3.2.0", "< 7"
  spec.add_dependency "activerecord", ">= 3.2.0", "< 7"
  spec.add_dependency "activesupport", ">= 3.2.0", "< 7"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"

  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "combustion", "~> 1.3"
  spec.add_development_dependency "sqlite3", "~> 1.3"
end
