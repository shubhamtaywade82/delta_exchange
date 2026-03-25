# frozen_string_literal: true

module DeltaExchange
  module Resources
    # Session keepalive endpoints; confirm paths against your Delta environment (not in public REST slate list).
    class Heartbeat < Base
      def create(payload)
        post("/v2/heartbeats", payload)
      end

      def ack(payload)
        put("/v2/heartbeats/ack", payload)
      end

      def all(params = {})
        get("/v2/heartbeats", params)
      end
    end
  end
end
