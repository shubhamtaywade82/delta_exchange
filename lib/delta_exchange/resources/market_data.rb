# frozen_string_literal: true

require "cgi"

module DeltaExchange
  module Resources
    class MarketData < Base
      def l2_orderbook(symbol, params = {})
        sym = CGI.escape(symbol.to_s)
        get("/v2/l2orderbook/#{sym}", params, authenticate: false)
      end

      def trades(symbol, params = {})
        sym = CGI.escape(symbol.to_s)
        get("/v2/trades/#{sym}", params, authenticate: false)
      end

      def candles(params = {})
        get("/v2/history/candles", params, authenticate: false)
      end

      def sparklines(params = {})
        get("/v2/history/sparklines", params, authenticate: false)
      end

      def stats(params = {})
        get("/v2/stats", params, authenticate: false)
      end

      def mark_price(symbol)
        sym = CGI.escape(symbol.to_s)
        get("/v2/mark_price/#{sym}", {}, authenticate: false)
      end

      def insurance_fund
        get("/v2/insurance_fund", {}, authenticate: false)
      end

      def option_greeks(params = {})
        get("/v2/option_greeks", params, authenticate: false)
      end
    end
  end
end
