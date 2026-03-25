# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Models::Order do
  describe ".all" do
    before do
      stub_request(:get, %r{https://cdn-ind\.testnet\.deltaex\.org/v2/orders})
        .to_return(status: 200, body: '{"success":true,"result":[{"id": 1, "product_id": 27}]}')
    end

    it "returns active orders over authenticated connection securely" do
      orders = described_class.all

      expect(orders).to be_an(Array)
      expect(orders.first).to be_a(described_class)
      expect(orders.first.id).to eq(1)
    end
  end

  describe ".create" do
    before do
      stub_request(:post, %r{https://cdn-ind\.testnet\.deltaex\.org/v2/orders})
        .to_return(status: 200, body: '{"success":true,"result":{"id": 123, "status": "open", "product_id": 27}}')
    end

    it "constructs a brand new order onto the testnet safely" do
      order = described_class.create({
                                       product_id: 27,
                                       size: 1,
                                       side: "buy",
                                       order_type: "limit_order",
                                       limit_price: "25000"
                                     })

      expect(order).to be_a(described_class)
      expect(order.status).to eq("open")
      expect(order.product_id).to eq(27)
    end
  end
end
