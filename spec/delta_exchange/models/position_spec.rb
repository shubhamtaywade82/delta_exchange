# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Models::Position do
  describe ".all" do
    before do
      stub_request(:get, %r{https://cdn-ind\.testnet\.deltaex\.org/v2/positions})
        .to_return(status: 200, body: '{"success":true,"result":[{"id": 456, "product_id": 27}]}')
    end

    it "fetches live testnet open derivatives positions natively" do
      positions = described_class.all
      
      expect(positions).to be_an(Array)
      expect(positions.first).to be_a(described_class)
      expect(positions.first.product_id).to eq(27)
    end
  end
end
