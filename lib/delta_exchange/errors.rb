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
  end

  class AuthenticationError < ApiError; end
  class InvalidAuthenticationError < AuthenticationError; end
  class RateLimitError < ApiError; end
  class ValidationError < Error; end
  class NotFoundError < ApiError; end
  class InternalServerError < ApiError; end
  class InputExceptionError < ApiError; end
end
