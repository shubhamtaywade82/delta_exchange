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
        payload = instance_variable_get(:@raw_attributes) || instance_variable_get(:@attributes)
        result = contract.call(payload)

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
