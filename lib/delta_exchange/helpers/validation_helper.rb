# frozen_string_literal: true

module DeltaExchange
  module Helpers
    module ValidationHelper
      def validate_params!(params, contract_class)
        contract = contract_class.new
        result = contract.call(params)

        raise ValidationError, "Invalid parameters: #{result.errors.to_h}" unless result.success?

        result.to_h
      end

      def validate!
        contract_class = self.class.respond_to?(:validation_contract) ? self.class.validation_contract : nil
        return unless contract_class

        contract = contract_class.new
        result = contract.call(@attributes)

        return if result.success?

        @errors = result.errors.to_h
        raise ValidationError, "Invalid parameters: #{@errors.inspect}"
      end

      def valid?
        @errors.nil? || @errors.empty?
      end
    end
  end
end
