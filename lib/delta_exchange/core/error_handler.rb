# frozen_string_literal: true

module DeltaExchange
  module Core
    class ErrorHandler
      def self.handle(error)
        case error
        when Dry::Validation::Result
          raise Error, "Validation failed: #{error.errors.to_h}"
        else
          raise Error, error.message
        end
      end
    end
  end
end
