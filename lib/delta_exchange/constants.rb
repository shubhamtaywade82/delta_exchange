# frozen_string_literal: true

module DeltaExchange
  module Constants
    module Urls
      REST_PRODUCTION = "https://api.india.delta.exchange"
      REST_TESTNET = "https://cdn-ind.testnet.deltaex.org"
      WEBSOCKET_PRODUCTION = "wss://api.india.delta.exchange/v2/websocket"
      WEBSOCKET_TESTNET = "wss://cdn-ind.testnet.deltaex.org/v2/websocket"
    end

    module ContractType
      PERPETUAL_FUTURES = "perpetual_futures"
      CALL_OPTIONS = "call_options"
      PUT_OPTIONS = "put_options"
      MOVE_OPTIONS = "move_options"
      SPREADS = "spreads"
      FUTURES = "futures"

      ALL = [PERPETUAL_FUTURES, CALL_OPTIONS, PUT_OPTIONS, MOVE_OPTIONS, SPREADS, FUTURES].freeze
    end

    module OrderType
      LIMIT = "limit_order"
      MARKET = "market_order"
      STOP_LIMIT = "stop_limit_order"
      STOP_MARKET = "stop_market_order"

      ALL = [LIMIT, MARKET, STOP_LIMIT, STOP_MARKET].freeze
    end

    module Side
      BUY = "buy"
      SELL = "sell"

      ALL = [BUY, SELL].freeze
    end

    module TimeInForce
      GTC = "gtc"
      IOC = "ioc"
      FOK = "fok"

      ALL = [GTC, IOC, FOK].freeze
    end

    module ProductState
      UPCOMING = "upcoming"
      LIVE = "live"
      EXPIRED = "expired"
      SETTLED = "settled"

      ALL = [UPCOMING, LIVE, EXPIRED, SETTLED].freeze
    end

    module OrderState
      OPEN = "open"
      PENDING = "pending"
      CLOSED = "closed"
      CANCELLED = "cancelled"

      ALL = [OPEN, PENDING, CLOSED, CANCELLED].freeze
    end

    module MarginMode
      CROSS = "cross"
      ISOLATED = "isolated"

      ALL = [CROSS, ISOLATED].freeze
    end
  end
end
