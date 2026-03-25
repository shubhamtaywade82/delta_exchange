# frozen_string_literal: true

module DeltaExchange
  module Models
    class WalletTransaction < Core::BaseModel
      attributes :id, :asset_id, :amount, :type, :status, :timestamp,
                 :tx_hash, :network, :address

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Wallet.new
        end

        def all(params = {})
          build_from_response(resource.transactions(params))
        end
      end
    end
  end
end
