# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Client do
  let(:testnet_url) { DeltaExchange::Configuration::TESTNET_URL }
  let(:production_url) { DeltaExchange::Configuration::PRODUCTION_URL }

  describe "#initialize" do
    it "sets testnet url explicitly" do
      client = described_class.new(api_key: "k", api_secret: "s", testnet: true)
      expect(client.root_url).to eq(testnet_url)
    end

    it "overrides testnet when explicitly false" do
      client = described_class.new(api_key: "k", api_secret: "s", testnet: false)
      expect(client.root_url).to eq(production_url)
    end

    it "raises ArgumentError when missing credentials on authenticated calls" do
      client = described_class.new(api_key: "", api_secret: "")
      expect { client.get("/v2/profile") }.to raise_error(DeltaExchange::AuthenticationError)
    end
    
    it "allows unauthenticated calls when explicitly told" do
      client = described_class.new(api_key: nil, api_secret: nil)
      # Ensure it proceeds to connection rather than immediately blocking on `ensure_credentials!`
      expect(client.connection).to receive(:send).and_return(
        double("Faraday::Response", status: 200, body: '{"success":true}', success?: true)
      )
      expect(client.get("/v2/products", {}, authenticate: false)).to eq({ "success" => true })
    end
  end
end
