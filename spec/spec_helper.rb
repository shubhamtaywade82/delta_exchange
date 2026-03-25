# frozen_string_literal: true

require "dotenv/load"
require "webmock/rspec"
require "vcr"
require "delta_exchange"

VCR.configure do |config|
  config.cassette_library_dir = "spec/support/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!

  # Filter sensitive environmental keys from testnet captures
  config.filter_sensitive_data("<API_KEY>") { ENV["DELTA_API_KEY"] || "dummy_api_key" }
  config.filter_sensitive_data("<API_SECRET>") { ENV["DELTA_API_SECRET"] || "dummy_api_secret" }

  # Explicitly scrub headers out of intercepts globally using correct lowercase names
  config.filter_sensitive_data("<SIGNATURE>") do |interaction|
    interaction.request.headers["signature"]&.first
  end
  config.filter_sensitive_data("<TIMESTAMP>") do |interaction|
    interaction.request.headers["timestamp"]&.first
  end
end

RSpec.configure do |config|
  # Enforce Testnet Globally and configure dummies if API keys missing
  config.before(:all) do
    DeltaExchange.configure do |c|
      c.api_key = ENV["DELTA_API_KEY"] || "dummy_api_key"
      c.api_secret = ENV["DELTA_API_SECRET"] || "dummy_api_secret"
      c.testnet = true
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
