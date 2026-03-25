# frozen_string_literal: true

module DeltaExchange
  module Models
    class TradingPreferences < Core::BaseModel
      attributes :user_id, :vip_level, :volume_30d, :referral_discount_factor,
                 :default_auto_topup, :email_preferences, :notification_preferences,
                 :deto_balance, :deto_for_commission, :cancel_on_disconnect

      class << self
        def resource
          @resource ||= DeltaExchange::Client.new.account
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
