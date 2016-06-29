# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fourth/version'

Gem::Specification.new do |spec|
  spec.name          = "fourth"
  spec.version       = Fourth::VERSION
  spec.authors       = ["Carl Douglas"]
  spec.email         = ["carl.douglas@abletech.co.nz"]

  spec.summary       = %q{A Command Line Minute Doc tool}
  spec.description   = %q{Make Minutedock API calls}
  spec.homepage      = "http://github.com/carld/fourth"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "bin/fourth"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "thor"
  spec.add_dependency "httparty"
  spec.add_dependency "logger"
end
