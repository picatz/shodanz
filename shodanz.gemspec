# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shodanz/version'

Gem::Specification.new do |spec|
  spec.name          = 'shodanz'
  spec.version       = Shodanz::VERSION
  spec.authors       = ["Kent 'picatz' Gruber"]
  spec.email         = ['kgruber1@emich.edu']

  spec.summary       = "A modern, async Ruby gem for Shodan, the world's first search engine for Internet-connected devices."
  spec.description   = 'Featuring full support for the REST, Streaming and Exploits API'
  spec.homepage      = 'https://github.com/picatz/shodanz'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'async-http', '>= 0.38.1', '< 0.62.0'
  spec.add_dependency 'async', '>= 1.17.1', '< 2.9.0'

  spec.add_development_dependency 'async-rspec', '~> 1.17.0'
  spec.add_development_dependency 'bundler', '~> 2.4.0'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rake', '~> 13.1.0'
  spec.add_development_dependency 'rb-readline', '~> 0.5.5'
  spec.add_development_dependency 'rspec', '~> 3.13.0'
end
