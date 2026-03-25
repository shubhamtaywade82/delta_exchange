# frozen_string_literal: true

require "faye/websocket"
require "eventmachine"
require "json"

module DeltaExchange
  module Websocket
    class Connection
      RECONNECT_DELAY = 5

      def initialize(url, api_key: nil, api_secret: nil, &on_message)
        @url = url
        @api_key = api_key
        @api_secret = api_secret
        @on_message = on_message
        @ws = nil
        @stop = false
      end

      def start
        @thr = Thread.new { loop_run }
      end

      def stop
        @stop = true
        @ws&.close
        EM.stop if EM.reactor_running?
      end

      def send_json(data)
        @ws&.send(data.to_json)
      end

      private

      def loop_run
        until @stop
          begin
            if EM.reactor_running?
              setup_ws
              # Wait explicitly if the reactor is running on another thread/loop, but here we just sleep loop
              sleep RECONNECT_DELAY while @ws&.ready_state == 1 && !@stop
            else
              EM.run { setup_ws }
            end
          rescue StandardError => e
            DeltaExchange.logger.error("[DeltaExchange::WS] Loop Error: #{e.message}")
          end
          sleep RECONNECT_DELAY unless @stop
        end
      end

      def authenticate!
        timestamp = Time.now.to_i
        path = "/v2/websocket"
        method = "GET"
        signature = Auth.sign(method, timestamp.to_s, path, "", "", @api_secret)

        send_json({
                    type: "auth",
                    api_key: @api_key,
                    timestamp: timestamp,
                    signature: signature
                  })
      end

      def setup_ws
        @ws = Faye::WebSocket::Client.new(@url)

        @ws.on :open do |_|
          DeltaExchange.logger.info("[DeltaExchange::WS] Connected")
          authenticate! if @api_key && @api_secret
        end

        @ws.on :message do |event|
          @on_message&.call(JSON.parse(event.data))
        rescue StandardError
          @on_message&.call(event.data)
        end

        @ws.on :close do |event|
          DeltaExchange.logger.warn("[DeltaExchange::WS] Closed: #{event.code} #{event.reason}")
          EM.stop unless EM.reactor_running? # Only stop if we started it
        end

        @ws.on :error do |event|
          DeltaExchange.logger.error("[DeltaExchange::WS] Error: #{event.message}")
        end
      end
    end
  end
end
