
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "policy_manager/version"

Gem::Specification.new do |spec|
  spec.name          = "policy_manager"
  spec.version       = PolicyManager::VERSION
  spec.authors       = ["jeanne"]
  spec.email         = ["jeanne.bailhache@gmail.com"]

  spec.summary       = %q{terms & conditions}
  spec.description   = %q{handle the creation and signing of terms}
  spec.homepage      = "https://github.com/jeanne-b-/policy_manager"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # DEPENDENCIES
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"

  spec.add_dependency "aasm"
  spec.add_dependency "carrierwave"
  spec.add_dependency "cocoon"
  spec.add_dependency "rubyzip"
  spec.add_dependency "classy_enum"
  spec.add_dependency 'inherited_resources'
  spec.add_dependency "redcarpet"
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'globalid'
  spec.add_dependency 'turbolinks'
  spec.add_dependency "zip-zip"
end
