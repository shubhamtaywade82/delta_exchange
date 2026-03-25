# frozen_string_literal: true

require "cgi"

module DeltaExchange
  module Resources
    class Products < Base
      def all(params = {})
        get("/v2/products", params, authenticate: false)
      end

      def find(symbol)
        sym = CGI.escape(symbol.to_s)
        get("/v2/products/#{sym}", {}, authenticate: false)
      end

      def tickers(params = {})
        get("/v2/tickers", params, authenticate: false)
      end

      def ticker(symbol)
        sym = CGI.escape(symbol.to_s)
        get("/v2/tickers/#{sym}", {}, authenticate: false)
      end

      def settlement_prices(params = {})
        get("/v2/settlement_prices", params, authenticate: false)
      end

      def leverage(product_id)
        get("/v2/products/#{product_id}/orders/leverage")
      end

      def set_leverage(product_id, payload)
        post("/v2/products/#{product_id}/orders/leverage", payload)
      end
    end
  end
end
