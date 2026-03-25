# frozen_string_literal: true

module DeltaExchange
  module Websocket
    class Client
      def initialize(api_key: nil, api_secret: nil, testnet: nil)
        @api_key = api_key || DeltaExchange.configuration.api_key
        @api_secret = api_secret || DeltaExchange.configuration.api_secret
        use_testnet = testnet.nil? ? DeltaExchange.configuration.testnet : testnet
        @url = use_testnet ? Constants::Urls::WEBSOCKET_TESTNET : Constants::Urls::WEBSOCKET_PRODUCTION
        @callbacks = Hash.new { |h, k| h[k] = [] }
        @connection = Connection.new(@url, api_key: @api_key, api_secret: @api_secret) do |msg|
          emit(:message, msg)
        end
      end

      def on(event, &block)
        @callbacks[event] << block
        self
      end

      def connect!
        @connection.start
        self
      end

      def subscribe(channels)
        @connection.send_json({
                                type: "subscribe",
                                payload: { channels: channels }
                              })
      end

      def unsubscribe(channels)
        @connection.send_json({
                                type: "unsubscribe",
                                payload: { channels: channels }
                              })
      end

      def close
        @connection.stop
      end

      private

      def emit(event, data)
        @callbacks[event].each { |cb| cb.call(data) }
      end
    end
  end
end
