# frozen_string_literal: true

require "cgi"

module DeltaExchange
  module Resources
    class Orders < Base
      def all(params = {})
        get("/v2/orders", params)
      end

      def find(id)
        get("/v2/orders/#{id}")
      end

      def find_by_client_order_id(client_order_id)
        oid = CGI.escape(client_order_id.to_s)
        get("/v2/orders/client_order_id/#{oid}")
      end

      def history(params = {})
        get("/v2/orders/history", params)
      end

      def create(payload)
        post("/v2/orders", payload)
      end

      def create_bracket(payload)
        post("/v2/orders/bracket", payload)
      end

      def create_batch(payload)
        post("/v2/orders/batch", payload)
      end

      def update(payload)
        put("/v2/orders", payload)
      end

      def update_bracket(payload)
        put("/v2/orders/bracket", payload)
      end

      def update_batch(payload)
        put("/v2/orders/batch", payload)
      end

      def cancel(payload)
        delete("/v2/orders", payload)
      end

      def cancel_all(params = {})
        delete("/v2/orders/all", {}, params)
      end

      def cancel_batch(payload)
        delete("/v2/orders/batch", payload)
      end

      def cancel_after(payload)
        post("/v2/orders/cancel_after", payload)
      end

      def set_leverage(payload)
        post("/v2/orders/leverage", payload)
      end
    end
  end
end
