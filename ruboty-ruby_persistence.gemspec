# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/ruby_persistence/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-ruby_persistence"
  spec.version       = Ruboty::RubyPersistence::VERSION
  spec.authors       = ["Yuji Nakayama"]
  spec.email         = ["nkymyj@gmail.com"]

  spec.summary       = 'A Ruboty handler for persisting Ruby variables'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/yujinakayama/ruboty-ruby_persistence'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'ruboty', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
