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
    end
  end
end
