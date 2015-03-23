# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'model_operations/version'

Gem::Specification.new do |spec|
  spec.name          = 'model_operations'
  spec.version       = ModelOperations::VERSION
  spec.authors       = ['Pawel Niemczyk']
  spec.email         = ['p.niemczyk@pilot.co']
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '>= 3.0.2'
  spec.add_development_dependency 'bundler', '>= 1.6'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard', '~> 2.12'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'awesome_print', '~> 1.6'
end
