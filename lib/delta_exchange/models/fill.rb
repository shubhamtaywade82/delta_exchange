# frozen_string_literal: true

module DeltaExchange
  module Models
    class Fill < Core::BaseModel
      attributes :id, :order_id, :product_id, :symbol, :size, :price, :side,
                 :role, :fee, :fee_asset_id, :margin, :timestamp

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Fills.new
        end

        def all(params = {})
          build_from_response(resource.all(params))
        end
      end
    end
  end
end
