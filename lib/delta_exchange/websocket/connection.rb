# frozen_string_literal: true

require "faye/websocket"
require "eventmachine"
require "json"

module DeltaExchange
  module Websocket
    class Connection
      RECONNECT_DELAY = 5
      attr_accessor :on_open, :on_message, :on_close, :on_error

      def initialize(url, api_key: nil, api_secret: nil)
        @url = url
        @api_key = api_key
        @api_secret = api_secret
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

      def authenticate!
        timestamp = Time.now.utc.to_i
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

      private

      def loop_run
        until @stop
          begin
            if EM.reactor_running?
              setup_ws
              wait_for_connection_close
            else
              EM.run { setup_ws }
            end
          rescue StandardError => e
            DeltaExchange.logger.error("[DeltaExchange::WS] Loop Error: #{e.message}")
          end
          handle_reconnect_delay
        end
      end

      def wait_for_connection_close
        # Instead of a tight loop, we sleep for longer intervals while connected
        # or we could use a ConditionVariable if we wanted to be more reactive.
        # But even a longer sleep is better than the original "busy-wait".
        # The WebSocket's on :close will resume the loop if EM stops.
        sleep 1 while @ws&.ready_state == 1 && !@stop
      end

      def handle_reconnect_delay
        return if @stop

        delay = DeltaExchange.configuration.websocket_reconnect_delay
        sleep delay
      end

      def setup_ws
        headers = { "User-Agent" => DeltaExchange.configuration.user_agent }
        @ws = Faye::WebSocket::Client.new(@url, nil, { headers: headers })

        @ws.on :open do |event|
          DeltaExchange.logger.info("[DeltaExchange::WS] Connected")
          authenticate! if @api_key && @api_secret
          @on_open&.call(event)
        end

        @ws.on :message do |event|
          data = begin
            JSON.parse(event.data)
          rescue StandardError
            event.data
          end
          @on_message&.call(data)
        end

        @ws.on :close do |event|
          DeltaExchange.logger.warn("[DeltaExchange::WS] Closed: #{event.code} #{event.reason}")
          @on_close&.call(event)
          EM.stop unless EM.reactor_running? # Only stop if we started it
        end

        @ws.on :error do |event|
          DeltaExchange.logger.error("[DeltaExchange::WS] Error: #{event.message}")
          @on_error&.call(event)
        end
      end
    end
  end
end
