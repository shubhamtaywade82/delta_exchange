# frozen_string_literal: true

module DeltaExchange
  module Models
    class Product < Core::BaseModel
      attributes :id, :symbol, :description, :contract_type, :contract_value, :tick_size,
                 :underlying_asset_symbol, :quoting_asset_symbol, :settlement_asset_symbol,
                 :state, :funding_method, :impact_size, :initial_margin, :maintenance_margin,
                 :strike_price, :expiration_time

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Products.new
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
