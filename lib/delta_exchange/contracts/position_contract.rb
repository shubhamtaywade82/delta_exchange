# frozen_string_literal: true

require "dry-validation"

module DeltaExchange
  module Contracts
    class PositionContract < Dry::Validation::Contract
      params do
        required(:product_id).filled(:integer)
        optional(:amount).maybe(:string)
        optional(:type).maybe(:string, included_in?: %w[add remove])
        optional(:leverage).maybe(:string)
        optional(:auto_topup).maybe(:bool)
      end

      rule(:amount) do
        if values[:type] && values[:amount].nil?
          key.failure("is required when type is present")
        end
      end
    end
  end
end
