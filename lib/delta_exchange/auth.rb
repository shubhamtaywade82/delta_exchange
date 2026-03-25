# frozen_string_literal: true

require "openssl"

module DeltaExchange
  class Auth
    def self.sign(method, timestamp, path, query_string, payload, secret)
      prehash = "#{method.upcase}#{timestamp}#{path}#{query_string}#{payload}"
      OpenSSL::HMAC.hexdigest("SHA256", secret, prehash)
    end
  end
end
