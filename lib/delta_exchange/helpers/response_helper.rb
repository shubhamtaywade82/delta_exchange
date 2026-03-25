# frozen_string_literal: true

module DeltaExchange
  module Helpers
    module ResponseHelper
      def handle_response(response)
        case response.status
        when 200..299 then parse_json(response.body)
        when 429 then handle_rate_limit(response)
        else handle_api_error(response)
        end
      end

      private

      def parse_json(body)
        return {}.with_indifferent_access if body.blank?

        JSON.parse(body).with_indifferent_access
      rescue JSON::ParserError
        raise Error, "Invalid JSON response: #{body}"
      end

      def handle_rate_limit(response)
        retry_after = response.headers["X-RATE-LIMIT-RESET"]&.to_i
        raise RateLimitError.new("Rate limited", retry_after_ms: retry_after, response_body: parse_json(response.body))
      end

      def handle_api_error(response)
        body = parse_json(response.body)
        message = body[:error] || body[:message] || "HTTP #{response.status}"
        raise ApiError.new(message, code: response.status, response_body: body)
      end
    end
  end
end
