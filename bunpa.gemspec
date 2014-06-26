$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bunpa/version"

Gem::Specification.new do |s|
  s.name        = 'bunpa'
  s.version     = Bunpa::VERSION
  s.authors     = ["Daniel Carter"]
  s.email       = 'clownba0t@gmail.com'
  s.homepage    = 'https://github.com/clownba0t/bunpa'
  s.summary     = "#{s.name} v#{s.version}"
  s.description = "A simple wrapper around the MeCab Japanese grammar parser than maintains formatting."
  s.files       = Dir["bin/*, lib/**/*", "MIT-LICENSE", "README.md"]
  s.test_files  = Dir["spec/**/*"]
  s.license     = 'MIT'

  s.add_dependency 'mecab', '~> 0.996'
  s.add_development_dependency 'rspec'
end
