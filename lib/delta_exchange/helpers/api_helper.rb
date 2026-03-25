# frozen_string_literal: true

module DeltaExchange
  module Helpers
    module APIHelper
      def handle_response(response)
        return response if response.is_a?(Array) || response.is_a?(Hash)

        raise Error, "Unexpected API response format: #{response.inspect}"
      end
    end
  end
end
