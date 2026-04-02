# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Models::Product do
  describe "#contract_lot_multiplier" do
    it "prefers lot_size when present" do
      product = described_class.new(
        { "symbol" => "BTCUSD", "contract_value" => "0.001", "lot_size" => "0.002" },
        skip_validation: true
      )

      expect(product.contract_lot_multiplier).to eq(BigDecimal("0.002"))
    end

    it "falls back to contract_value when lot_size is blank" do
      product = described_class.new(
        { "symbol" => "BTCUSD", "contract_value" => "0.001" },
        skip_validation: true
      )

      expect(product.contract_lot_multiplier).to eq(BigDecimal("0.001"))
    end
  end
end
