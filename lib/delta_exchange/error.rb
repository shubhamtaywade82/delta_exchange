# frozen_string_literal: true

module DeltaExchange
  class Error < StandardError; end

  class ApiError < Error
    attr_reader :code, :response_body

    def initialize(message = nil, code: nil, response_body: nil)
      super(message)
      @code = code
      @response_body = response_body
    end

    def self.from_hash(hash, status: nil)
      msg = hash[:error] || hash[:message] || "API error"
      new(msg, code: status || hash[:code], response_body: hash)
    end
  end

  class AuthenticationError < ApiError; end
  class InvalidAuthenticationError < AuthenticationError; end

  class RateLimitError < ApiError
    attr_reader :retry_after_seconds

    def initialize(message = nil, retry_after_seconds: nil, **)
      super(message, **)
      @retry_after_seconds = retry_after_seconds
    end
  end

  class ValidationError < Error; end
  class NotFoundError < ApiError; end
  class InternalServerError < ApiError; end
  class InputExceptionError < ApiError; end
end
