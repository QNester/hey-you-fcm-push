require_relative 'lib/hey_you_fcm_push/version'

Gem::Specification.new do |spec|
  spec.name          = "hey-you-fcm-push"
  spec.version       = HeyYouFcmPush::VERSION
  spec.authors       = ["Sergey Nesterov"]
  spec.email         = ["qnesterr@gmail.com"]

  spec.summary       = %q{Send fcm pushes via hey-you}
  spec.description   = %q{Send fcm pushes via hey-you using google fcm protocol}
  spec.homepage      = "https://github.com/QNester/hey-you-fcm-push"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/QNester/hey-you-fcm-push.git"
  spec.metadata["changelog_uri"] = "https://github.com/QNester/hey-you-fcm-push/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "hey-you", '>= 1.4'
  spec.add_runtime_dependency "googleauth", '~> 0.14'
  spec.add_runtime_dependency "httparty", '~> 0.18'

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", '~> 3.4'
  spec.add_development_dependency "ffaker", '~> 2.15'
end
