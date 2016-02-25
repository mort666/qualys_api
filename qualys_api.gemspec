# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qualys_api/version'

Gem::Specification.new do |spec|
  spec.name          = "qualys_api"
  spec.version       = Qualys::VERSION
  spec.authors       = ["Stephen Kapp"]
  spec.email         = ["mort666@virus.org"]

  spec.summary       = %q{Qualys API Wrapper}
  spec.description   = %q{Qualys API Wrapper, supports scan result download and knowledge base access}
  spec.homepage      = "https://github.com/mort666/qualys_api"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "multi_xml"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.22"
end
