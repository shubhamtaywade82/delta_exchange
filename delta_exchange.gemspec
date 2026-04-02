# frozen_string_literal: true

require_relative "lib/delta_exchange/version"

Gem::Specification.new do |spec|
  spec.name = "delta_exchange"
  spec.version = DeltaExchange::VERSION
  spec.authors = ["Shubham Taywade"]
  spec.email = ["shubhamtaywade82@gmail.com"]

  spec.summary = "A Ruby client for the Delta Exchange API."
  spec.description = "Ruby client for the Delta Exchange India REST API (v2) and optional WebSocket feed: products, orders, positions, wallet, and market data. See https://docs.delta.exchange/"
  spec.homepage = "https://github.com/shubhamtaywade82/delta_exchange"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/shubhamtaywade82/delta_exchange/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 7.0"
  spec.add_dependency "dry-validation", "~> 1.8"
  spec.add_dependency "eventmachine", "~> 1.2"
  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faye-websocket", "~> 0.11"
  spec.add_dependency "zeitwerk", ">= 2.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
