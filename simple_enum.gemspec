lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_enum"
  spec.version       = SimpleEnum::VERSION
  spec.authors       = ["necojackarc"]
  spec.email         = ["necojackarc@gmail.com"]

  spec.summary       = %q{Simple Enumerated Type}
  spec.description   = %q{simple_enum provides really simple enumerated type}
  spec.homepage      = "https://github.com/necojackarc/simple_enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "i18n"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter"
end
