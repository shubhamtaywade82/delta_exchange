# frozen_string_literal: true

require "dry-validation"

module DeltaExchange
  module Contracts
    class WalletTransferContract < Dry::Validation::Contract
      params do
        required(:asset_id).filled(:integer)
        required(:amount).filled(:string)
        required(:sub_account_id).filled(:integer)
        required(:method).filled(:string, included_in?: %w[deposit withdraw])
      end
    end
  end
end
