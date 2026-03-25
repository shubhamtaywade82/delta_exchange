# frozen_string_literal: true

module DeltaExchange
  module Models
    class Asset < Core::BaseModel
      attributes :id, :symbol, :precision, :is_deposit_enabled, :is_withdrawal_enabled, :network

      class << self
        def resource
          @resource ||= DeltaExchange::Client.new.assets
        end

        def all
          build_from_response(resource.all)
        end

        def find(id_or_symbol)
          build_from_response(resource.find(id_or_symbol))
        end
      end
    end
  end
end
