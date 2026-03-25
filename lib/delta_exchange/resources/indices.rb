# frozen_string_literal: true

module DeltaExchange
  module Resources
    class Indices < Base
      def all
        get("/v2/indices", {}, authenticate: false)
      end
    end
  end
end
