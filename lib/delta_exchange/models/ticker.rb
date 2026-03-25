# frozen_string_literal: true

module DeltaExchange
  module Models
    class Ticker < Core::BaseModel
      attributes :symbol, :contract_type, :mark_price, :spot_price, :strike_price,
                 :open, :high, :low, :close, :volume, :turnover, :turnover_usd,
                 :size, :quotes, :price_band, :greeks, :funding_rate

      class << self
        def resource
          @resource ||= DeltaExchange::Client.new.products
        end

        def all(params = {})
          build_from_response(resource.tickers(params))
        end

        def find(symbol)
          build_from_response(resource.ticker(symbol))
        end
      end
    end
  end
end
