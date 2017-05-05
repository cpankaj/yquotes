# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yquotes/version'

Gem::Specification.new do |spec|
  spec.name          = "yquotes"
  spec.version       = YQuotes::VERSION
  spec.authors       = ["P Choudhary"]
  spec.email         = ["pankaj17n@outlook.com"]

  spec.summary       = "Get historical quotes from Yahoo"
  spec.homepage      = "https://github.com/cpankaj/yquotes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "daru", "~> 0.1.5"
end
