# frozen_string_literal: true

module DeltaExchange
  module Resources
    class Wallet < Base
      def balances
        get("/v2/wallet/balances")
      end

      def transactions(params = {})
        get("/v2/wallet/transactions", params)
      end

      def transactions_download(params = {})
        get("/v2/wallet/transactions/download", params)
      end

      def subaccount_transfer_history(params = {})
        get("/v2/wallets/sub_accounts_transfer_history", params)
      end

      def subaccount_transfer(payload)
        post("/v2/wallets/sub_account_balance_transfer", payload)
      end

      def withdrawals(params = {})
        get("/v2/wallet/withdrawals", params)
      end

      def deposits(params = {})
        get("/v2/wallet/deposits", params)
      end
    end
  end
end
