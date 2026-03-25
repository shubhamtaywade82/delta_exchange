# frozen_string_literal: true

module DeltaExchange
  module Models
    class FundingRate < Core::BaseModel
      attributes :product_id, :funding_rate, :funding_rate_daily, :funding_time

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::MarketData.new
        end

        def history(product_id, params = {})
          build_from_response(resource.funding_rates(params.merge(product_id: product_id)))
        end
      end
    end
  end
end
