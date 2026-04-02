# frozen_string_literal: true

module DeltaExchange
  class Configuration
    PRODUCTION_URL = Constants::Urls::REST_PRODUCTION
    TESTNET_URL = Constants::Urls::REST_TESTNET
    DEFAULT_CONNECT_TIMEOUT = 10
    DEFAULT_READ_TIMEOUT = 30
    DEFAULT_WRITE_TIMEOUT = 30

    attr_accessor :api_key, :api_secret, :testnet, :connect_timeout, :read_timeout, :write_timeout, :user_agent, :websocket_reconnect_delay, :time_zone, :auto_retry_rate_limit

    # When set, used as the REST base URL instead of {PRODUCTION_URL} / {TESTNET_URL}.
    attr_writer :base_url

    def initialize
      @api_key = ENV.fetch("DELTA_API_KEY", nil)
      @api_secret = ENV.fetch("DELTA_API_SECRET", nil)
      @testnet = ENV.fetch("DELTA_TESTNET", "false").to_s.casecmp("true").zero?
      @base_url = nil
      @connect_timeout = ENV.fetch("DELTA_CONNECT_TIMEOUT", DEFAULT_CONNECT_TIMEOUT).to_i
      @read_timeout = ENV.fetch("DELTA_READ_TIMEOUT", DEFAULT_READ_TIMEOUT).to_i
      @write_timeout = ENV.fetch("DELTA_WRITE_TIMEOUT", DEFAULT_WRITE_TIMEOUT).to_i
      @user_agent = ENV.fetch("DELTA_USER_AGENT", "delta-exchange-ruby")
      @websocket_reconnect_delay = ENV.fetch("DELTA_WS_RECONNECT_DELAY", 5).to_i
      @time_zone = ENV.fetch("DELTA_TIME_ZONE", "UTC")
      @auto_retry_rate_limit = ENV.fetch("DELTA_AUTO_RETRY_RATE_LIMIT", "false").to_s.casecmp("true").zero?
    end

    def base_url
      return @base_url if @base_url

      testnet? ? TESTNET_URL : PRODUCTION_URL
    end

    def testnet?
      @testnet == true
    end
  end
end
