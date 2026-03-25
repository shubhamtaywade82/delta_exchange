# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Models::Order, :vcr do
  describe ".all" do
    it "returns active orders over authenticated connection securely" do
      orders = described_class.all
      
      expect(orders).to be_an(Array)
      # Depending on the testnet state, this might be genuinely empty
      expect(orders.first).to be_a(described_class) unless orders.empty?
    end
  end

  describe ".create" do
    it "constructs a brand new order onto the testnet safely" do
      # 27 is the standard Product ID for BTCUSD on testnet mappings
      order = described_class.create({
        product_id: 27,
        size: 1,
        side: "buy",
        order_type: "limit_order",
        limit_price: "25000"
      })
      
      expect(order).to be_a(described_class)
      expect(order.status).not_to be_nil
      expect(order.product_id).to eq(27)
    end
  end
end
