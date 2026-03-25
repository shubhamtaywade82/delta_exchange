# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Auth do
  describe ".sign" do
    it "generates a deterministic HMAC-SHA256 signature natively" do
      method = "GET"
      timestamp = "1672531200"
      path = "/v2/products"
      query_string = "?symbol=BTCUSD"
      payload = ""
      secret = "dummy_secret_key"

      signature = described_class.sign(method, timestamp, path, query_string, payload, secret)

      # The signature algorithm is HMAC_SHA256 hex digest
      expected_payload = [method, timestamp, path, query_string, payload].join
      expected_signature = OpenSSL::HMAC.hexdigest("SHA256", secret, expected_payload)

      expect(signature).to eq(expected_signature)
      expect(signature).to be_a(String)
      expect(signature.length).to eq(64)
    end
  end
end
