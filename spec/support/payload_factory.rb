# frozen_string_literal: true

module FactoryBot
  # A very lightweight factory-like helper since we don't want to add a full factory_bot dependency
  # unless strictly requested. We can just use a simple Hub.
  class PayloadFactory
    def self.order(overrides = {})
      {
        product_id: 1,
        size: 10,
        side: "buy",
        order_type: "limit",
        limit_price: "50000",
        client_order_id: "test_#{Time.now.to_i}"
      }.merge(overrides)
    end

    def self.bracket_order(overrides = {})
      {
        product_id: 1,
        size: 10,
        side: "buy",
        order_type: "limit",
        limit_price: "50000",
        stop_loss_price: "49000",
        take_profit_price: "51000"
      }.merge(overrides)
    end

    def self.position(overrides = {})
      {
        product_id: 1,
        size: 10,
        entry_price: "50000",
        margin_type: "isolated"
      }.merge(overrides)
    end
  end
end
