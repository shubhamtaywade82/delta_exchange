# frozen_string_literal: true

module DeltaExchange
  module Resources
    class Account < Base
      def profile
        get("/v2/profile")
      end

      def trading_preferences
        get("/v2/users/trading_preferences")
      end

      def update_trading_preferences(payload)
        put("/v2/users/trading_preferences", payload)
      end

      def change_margin_mode(payload)
        put("/v2/users/margin_mode", payload)
      end

      def subaccounts
        get("/v2/sub_accounts")
      end

      def update_mmp(payload)
        put("/v2/users/update_mmp", payload)
      end

      def reset_mmp(payload)
        put("/v2/users/reset_mmp", payload)
      end

      def fee_tiers
        get("/v2/users/fee_tiers")
      end

      def referrals
        get("/v2/users/referrals")
      end

      # @deprecated Use {#trading_preferences} - Delta v2 uses +/v2/users/trading_preferences+.
      def preferences
        trading_preferences
      end

      # @deprecated Use {#update_trading_preferences}
      def update_preferences(payload)
        update_trading_preferences(payload)
      end
    end
  end
end
