# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shodanz/version"

Gem::Specification.new do |spec|
  spec.name          = "shodanz"
  spec.version       = Shodanz::VERSION
  spec.authors       = ["Kent 'picatz' Gruber"]
  spec.email         = ["kgruber1@emich.edu"]

  spec.summary       = %q{A modern Ruby gem for Shodan, the world's first search engine for Internet-connected devices.}
  spec.description   = %q{Featuring full support for the REST, Streaming and Exploits API}
  spec.homepage      = "https://github.com/picatz/shodanz"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]
  
  spec.add_dependency "unirest", "1.1.2"
  spec.add_dependency "json", "1.8.6"
  spec.add_dependency "oj", "3.3.8"
  
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
