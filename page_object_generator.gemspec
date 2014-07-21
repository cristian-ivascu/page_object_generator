# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'page_object_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "page_object_generator"
  spec.version       = PageObjectGenerator::VERSION
  spec.authors       = ["Cristian Ivascu"]
  spec.email         = ["cristian.ivascu@gmail.com"]
  spec.summary       = %q{A gem that generates page-objects based on URL}
  spec.description   = %q{This gem will build page objects and use a crawler to set up basic links. Its aim is to speed up development of automation}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
 
  spec.add_runtime_dependency "bundler", "~> 1.6"
  spec.add_runtime_dependency "rake"
  spec.add_runtime_dependency "mechanize"
  spec.add_runtime_dependency "nokogiri"
end
