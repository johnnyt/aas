# coding: utf-8
lib = File.expand_path "../lib", __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require "aas/version"

Gem::Specification.new do |spec|
  spec.name          = "aas"
  spec.version       = Aas::VERSION
  spec.authors       = ["JohnnyT"]
  spec.email         = ["ubergeek3141@gmail.com"]

  spec.summary       = "... as a service"
  spec.description   = "... as a service"
  spec.homepage      = "https://github.com/johnnyt/aas"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tnt"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest", "= 5.4.2"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "rake"
end
