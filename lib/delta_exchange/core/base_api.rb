# frozen_string_literal: true

module DeltaExchange
  module Core
    class BaseAPI
      include Helpers::ValidationHelper
      include Helpers::AttributeHelper

      attr_reader :client

      def initialize(client: nil)
        @client = client || Client.new
      end

      # Updated signatures to match Client's positional arguments.
      def get(endpoint, params = {}, authenticate: true)
        handle_response(client.get(endpoint, params, authenticate: authenticate))
      end

      def post(endpoint, payload = {}, authenticate: true)
        handle_response(client.post(endpoint, payload, authenticate: authenticate))
      end

      def put(endpoint, payload = {}, authenticate: true)
        handle_response(client.put(endpoint, payload, authenticate: authenticate))
      end

      def patch(endpoint, payload = {}, authenticate: true)
        handle_response(client.patch(endpoint, payload, authenticate: authenticate))
      end

      def delete(endpoint, payload = {}, params = {}, authenticate: true)
        handle_response(client.delete(endpoint, payload, params, authenticate: authenticate))
      end
    end
  end
end
