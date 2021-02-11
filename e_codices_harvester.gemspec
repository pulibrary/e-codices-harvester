require_relative 'lib/e_codices_harvester/version'

Gem::Specification.new do |spec|
  spec.name          = "e_codices_harvester"
  spec.version       = ECodicesHarvester::VERSION
  spec.authors       = ["Cliff Wulfman"]
  spec.email         = ["cwulfman@princeton.edu"]

  spec.summary       = %q{Harvests metadata and reference images}
  spec.homepage      = "https://github.com/pulibrary/e-codices-harvester"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pulibrary/e-codices-harvester"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "pry-byebug", "~> 3.9.0"
  spec.add_development_dependency "rubocop", "~> 0.93.1"

  spec.add_runtime_dependency 'faraday'
end
