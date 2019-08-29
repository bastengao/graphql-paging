
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "graphql/paging/version"

Gem::Specification.new do |spec|
  spec.name          = "graphql-paging"
  spec.version       = Graphql::Paging::VERSION
  spec.authors       = ["bastengao"]
  spec.email         = ["bastengao@gmail.com"]

  spec.summary       = %q{A page-based pagination extension for graphql gem}
  spec.homepage      = "https://github.com/bastengao/graphql-paging"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/*"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "graphql", ">= 1.8", "< 2"
  spec.add_dependency "kaminari", ">= 1.0.0"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
