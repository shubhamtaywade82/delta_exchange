# frozen_string_literal: true

module DeltaExchange
  module Models
    class TradingPreferences < Core::BaseModel
      attributes :cancel_on_disconnect

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Account.new
        end

        def fetch
          build_from_response(resource.trading_preferences)
        end
      end

      def update(cancel_on_disconnect: true)
        self.class.resource.update_trading_preferences(
          cancel_on_disconnect: cancel_on_disconnect
        )
      end
    end
  end
end
