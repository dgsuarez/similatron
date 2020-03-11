# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'similatron/version'

Gem::Specification.new do |spec|
  spec.name          = "similatron"
  spec.version       = Similatron::VERSION
  spec.authors       = ["Diego Guerra"]
  spec.email         = ["diego.guerra.suarez@gmail.com"]

  spec.summary       = 'Find similarities between files'
  spec.description   =
    "Similatron reports similarities between images, PDFs, or plain text files." \
    "It's particularly useful for tests for image generating functionalities"
  spec.homepage      = "https://github.com/dgsuarez/similatron"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
