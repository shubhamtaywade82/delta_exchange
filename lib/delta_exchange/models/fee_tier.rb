# frozen_string_literal: true

module DeltaExchange
  module Models
    class FeeTier < Core::BaseModel
      attributes :tier, :maker_fee, :taker_fee, :volume_30d, :min_volume

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Account.new
        end

        def current
          build_from_response(resource.fee_tiers)
        end
      end
    end
  end
end
