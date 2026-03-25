# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Models::Product, :vcr do
  describe ".all" do
    it "returns an array of Products" do
      products = described_class.all
      
      expect(products).to be_an(Array)
      expect(products.first).to be_a(described_class)
      expect(products.first.symbol).not_to be_nil
      expect(products.first.contract_type).not_to be_nil
    end
  end

  describe ".find" do
    it "returns a specific product natively by string symbol" do
      product = described_class.find("BTCUSD")
      
      expect(product).to be_a(described_class)
      expect(product.symbol).to eq("BTCUSD")
    end
  end
end
