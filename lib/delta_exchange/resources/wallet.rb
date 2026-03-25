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
        validate_transfer!(payload)
        post("/v2/wallets/sub_account_balance_transfer", payload)
      end

      private

      def validate_transfer!(payload)
        result = Contracts::WalletTransferContract.new.call(payload)
        return if result.success?

        raise ValidationError, "Invalid transfer parameters: #{result.errors.to_h}"
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
