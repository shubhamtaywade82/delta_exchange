# frozen_string_literal: true

require "faye/websocket"
require "eventmachine"
require "json"

module DeltaExchange
  module Websocket
    class Client
      attr_reader :url, :api_key, :api_secret

      def initialize(api_key: nil, api_secret: nil, testnet: nil)
        @api_key = api_key || DeltaExchange.configuration.api_key
        @api_secret = api_secret || DeltaExchange.configuration.api_secret
        testnet = DeltaExchange.configuration.testnet if testnet.nil?
        @url = testnet ? Constants::Urls::WEBSOCKET_TESTNET : Constants::Urls::WEBSOCKET_PRODUCTION

        @callbacks = {
          open: [],
          message: [],
          error: [],
          close: []
        }
        @ws = nil
      end

      def on(event, &block)
        @callbacks[event] << block if @callbacks.key?(event)
      end

      def connect!
        if EM.reactor_running?
          connect_ws
        else
          Thread.new do
            EM.run { connect_ws }
          end
        end
      end

      private

      def connect_ws
        @ws = Faye::WebSocket::Client.new(@url)

        @ws.on :open do |event|
          authenticate! if @api_key && @api_secret
          @callbacks[:open].each { |c| c.call(event) }
        end

        @ws.on :message do |event|
          data = begin
            JSON.parse(event.data)
          rescue StandardError
            event.data
          end
          @callbacks[:message].each { |c| c.call(data) }
        end

        @ws.on :error do |event|
          @callbacks[:error].each { |c| c.call(event) }
        end

        @ws.on :close do |event|
          @callbacks[:close].each { |c| c.call(event) }
          @ws = nil
        end
      end

      public

      def subscribe(channels)
        send_json({
                    type: "subscribe",
                    payload: {
                      channels: channels
                    }
                  })
      end

      def unsubscribe(channels)
        send_json({
                    type: "unsubscribe",
                    payload: {
                      channels: channels
                    }
                  })
      end

      def send_json(data)
        @ws&.send(data.to_json)
      end

      def close
        @ws&.close
        EM.stop if EM.reactor_running?
      end

      private

      def authenticate!
        timestamp = Time.now.to_i.to_s
        path = "/v2/websocket"
        method = "GET"
        signature = Auth.sign(method, timestamp, path, "", "", @api_secret)

        send_json({
                    type: "auth",
                    api_key: @api_key,
                    timestamp: timestamp,
                    signature: signature
                  })
      end
    end
  end
end
