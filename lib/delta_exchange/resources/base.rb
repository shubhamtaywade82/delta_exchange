# frozen_string_literal: true

module DeltaExchange
  module Resources
    class Base
      attr_reader :client

      def initialize(client = nil)
        @client = client || DeltaExchange::Client.new
      end

      protected

      def get(path, params = {}, authenticate: true)
        client.get(path, params, authenticate: authenticate)
      end

      def post(path, payload = {}, authenticate: true)
        client.post(path, payload, authenticate: authenticate)
      end

      def put(path, payload = {}, authenticate: true)
        client.put(path, payload, authenticate: authenticate)
      end

      def patch(path, payload = {}, authenticate: true)
        client.patch(path, payload, authenticate: authenticate)
      end

      def delete(path, payload = {}, params = {}, authenticate: true)
        client.delete(path, payload, params, authenticate: authenticate)
      end
    end
  end
end
