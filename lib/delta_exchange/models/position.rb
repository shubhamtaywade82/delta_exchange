# frozen_string_literal: true

module DeltaExchange
  module Models
    class Position < Core::BaseModel
      attributes :product_id, :size, :side, :entry_price, :mark_price, :liquidation_price,
                 :margin, :unrealized_pnl, :realized_pnl, :commission, :auto_topup

      class << self
        def resource
          @resource ||= DeltaExchange::Client.new.positions
        end

        def all(params = {})
          build_from_response(resource.margined(params))
        end

        def find(product_id)
          build_from_response(resource.find(product_id))
        end

        def close_all
          resource.close_all
        end
      end

      def adjust_margin(amount, type: "add")
        self.class.resource.adjust_margin(
          product_id: product_id,
          amount: amount,
          type: type
        )
      end

      def set_auto_topup(enabled)
        self.class.resource.set_auto_topup(
          product_id: product_id,
          auto_topup: enabled
        )
      end
    end
  end
end
