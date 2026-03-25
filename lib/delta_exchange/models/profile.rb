# frozen_string_literal: true

module DeltaExchange
  module Models
    class Profile < Core::BaseModel
      attributes :id, :email, :first_name, :last_name, :country, :kyc_status,
                 :referral_code, :is_subaccount, :margin_mode, :api_trading_enabled

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Account.new
        end

        def fetch
          build_from_response(resource.profile)
        end
      end
    end
  end
end
