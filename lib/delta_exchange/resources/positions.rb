# frozen_string_literal: true

module DeltaExchange
  module Resources
    class Positions < Base
      def all(params = {})
        get("/v2/positions", params)
      end

      def margined(params = {})
        get("/v2/positions/margined", params)
      end

      def find(product_id)
        get("/v2/positions/#{product_id}")
      end

      def adjust_margin(payload)
        post("/v2/positions/change_margin", payload)
      end

      def change_leverage(payload)
        post("/v2/positions/change_leverage", payload)
      end

      def auto_topup(payload)
        put("/v2/positions/auto_topup", payload)
      end

      def close_all(payload = {})
        post("/v2/positions/close_all", payload)
      end
    end
  end
end
