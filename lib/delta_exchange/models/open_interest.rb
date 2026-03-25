# frozen_string_literal: true

module DeltaExchange
  module Models
    class OpenInterest < Core::BaseModel
      attributes :product_id, :open_interest, :time

      class << self
        def resource
          @resource ||= DeltaExchange::Client.new.market_data
        end

        def history(product_id, params = {})
          build_from_response(resource.open_interest(params.merge(product_id: product_id)))
        end
      end
    end
  end
end
