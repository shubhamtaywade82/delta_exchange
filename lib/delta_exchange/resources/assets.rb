# frozen_string_literal: true

module DeltaExchange
  module Resources
    class Assets < Base
      def all
        get("/v2/assets", {}, authenticate: false)
      end
    end
  end
end
