# frozen_string_literal: true

require "dry-validation"

module DeltaExchange
  module Contracts
    class OrderContract < Dry::Validation::Contract
      params do
        required(:product_id).filled(:integer)
        required(:size).filled(:integer)
        required(:side).filled(:string, included_in?: DeltaExchange::Constants::Side::ALL)
        required(:order_type).filled(:string, included_in?: DeltaExchange::Constants::OrderType::ALL)
        optional(:limit_price).maybe(:string)
        optional(:stop_price).maybe(:string)
        optional(:client_order_id).maybe(:string)
        optional(:time_in_force).maybe(:string, included_in?: DeltaExchange::Constants::TimeInForce::ALL)
      end

      rule(:limit_price) do
        key.failure("is required for limit orders") if values[:order_type] == DeltaExchange::Constants::OrderType::LIMIT && values[:limit_price].nil?
      end
    end
  end
end
