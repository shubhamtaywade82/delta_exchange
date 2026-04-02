# frozen_string_literal: true

module DeltaExchange
  module Models
    class Product < Core::BaseModel
      attributes :id, :symbol, :description, :contract_type, :contract_value, :lot_size, :tick_size,
                 :underlying_asset_symbol, :quoting_asset_symbol, :settlement_asset_symbol,
                 :state, :funding_method, :impact_size, :initial_margin, :maintenance_margin,
                 :strike_price, :expiration_time

      # Delta documents per-contract sizing under product `contract_value` (and may add `lot_size`).
      # Order `size` is in contracts; multiply by this for notional / linear PnL in the quoting currency.
      def contract_lot_multiplier
        raw = lot_size.presence || contract_value
        return BigDecimal("0") if raw.blank?

        BigDecimal(raw.to_s)
      end

      class << self
        def resource
          @resource ||= DeltaExchange::Client.new.products
        end

        def all(params = {})
          build_from_response(resource.all(params))
        end

        def find(symbol)
          build_from_response(resource.find(symbol))
        end
      end

      def leverage
        self.class.resource.leverage(id)
      end

      def set_leverage(new_leverage)
        self.class.resource.set_leverage(id, { leverage: new_leverage })
      end
    end
  end
end
