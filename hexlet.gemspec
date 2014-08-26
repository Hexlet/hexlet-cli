# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hexlet/version'

Gem::Specification.new do |spec|
  spec.name          = "hexlet"
  spec.version       = Hexlet::VERSION
  spec.authors       = ["Kirill Mokevnin"]
  spec.email         = ["mokevnin@gmail.com"]
  spec.summary       = %q{hexlet cli}
  spec.description   = %q{hexlet cli}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "thor"
  spec.add_dependency "rest_client"
  spec.add_dependency "i18n"
  spec.add_dependency "minitar"
  # spec.add_dependency "childprocess"
end
