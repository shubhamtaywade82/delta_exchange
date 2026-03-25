# frozen_string_literal: true

module DeltaExchange
  module Models
    class Order < Core::BaseModel
      attributes :id, :client_order_id, :product_id, :side, :order_type, :limit_price,
                 :stop_price, :size, :filled_size, :unfilled_size, :average_fill_price,
                 :status, :created_at, :updated_at

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Orders.new
        end

        def all(params = {})
          build_from_response(resource.all(params))
        end

        def find(id)
          build_from_response(resource.find(id))
        end

        def create(payload)
          new(resource.create(payload))
        end
      end

      def cancel
        self.class.resource.cancel(product_id: product_id, id: id)
      end
    end
  end
end
