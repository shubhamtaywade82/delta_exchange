# frozen_string_literal: true

module DeltaExchange
  module Models
    class WalletBalance < Core::BaseModel
      attributes :asset_id, :asset_symbol, :balance, :available_balance, :pending_withdrawal, :commission

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Wallet.new
        end

        def all
          build_from_response(resource.balances)
        end

        def find_by_asset(symbol)
          all.find { |b| b.asset_symbol == symbol.to_s.upcase }
        end
      end
    end
  end
end
