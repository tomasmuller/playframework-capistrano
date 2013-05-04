# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'playframework/capistrano/version'

Gem::Specification.new do |spec|
  spec.name          = "playframework-capistrano"
  spec.version       = Playframework::Capistrano::VERSION
  spec.authors       = ["Tomás Augusto Müller"]
  spec.email         = ["tomas.am@gmail.com"]
  spec.description   = %q{PlayFramework / Capistrano integration Gem}
  spec.summary       = %q{Deploy PlayFramework apps with Capistrano}
  spec.homepage      = "https://github.com/tomasmuller/playframework-capistrano"
  spec.license       = "MIT"

  spec.add_dependency 'capistrano', '>=2.0.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
