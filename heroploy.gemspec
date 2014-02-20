# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroploy/version'

Gem::Specification.new do |spec|
  spec.name          = "heroploy"
  spec.version       = Heroploy::VERSION
  spec.authors       = ["John Brunton"]
  spec.email         = ["john_brunton@hotmail.co.uk"]
  spec.description   = %q{Helpful rake tasks to manage deploying to development, staging and production Heroku servers}
  spec.summary       = %q{Helpful rake tasks for deploying to Heroku}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.3"
  spec.add_dependency "travis"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "generator_spec"
  spec.add_development_dependency "coveralls"
end
