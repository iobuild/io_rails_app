# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'io_rails_app/version'

Gem::Specification.new do |spec|
  spec.name          = "io_rails_app"
  spec.version       = IoRailsApp::VERSION
  spec.authors       = ["Arly Xiao"]
  spec.email         = ["arlyxiao@163.com"]
  spec.summary       = %q{a simplest way to create a basic rails app.}
  spec.description   = %q{a simplest way to create a basic rails app.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
