# frozen_string_literal: true

module DeltaExchange
  module Resources
    class Fills < Base
      def all(params = {})
        get("/v2/fills", params)
      end

      def history_csv(params = {})
        get("/v2/fills/history/download/csv", params)
      end
    end
  end
end
