# frozen_string_literal: true

require "dry-validation"

module DeltaExchange
  module Core
    class BaseModel
      include Helpers::APIHelper
      include Helpers::AttributeHelper

      attr_reader :attributes, :errors

      def initialize(attributes = {}, skip_validation: false)
        @attributes = normalize_keys(attributes)
        @errors = {}
        validate! unless skip_validation
        assign_attributes
      end

      class << self
        attr_reader :defined_attributes

        def attributes(*args)
          @defined_attributes ||= []
          @defined_attributes.concat(args.map(&:to_s))
          args.each do |attr|
            define_method(attr) { @attributes[attr] }
          end
        end

        def build_from_response(response)
          return response.map { |r| new(r, skip_validation: true) } if response.is_a?(Array)

          new(response, skip_validation: true)
        end
      end

      def validate!
        return true unless self.class.respond_to?(:validation_contract)

        contract = self.class.validation_contract
        return true unless contract

        result = contract.call(@attributes)
        if result.failure?
          @errors = result.errors.to_h
          raise ValidationError, "Validation failed: #{@errors.inspect}"
        end
        true
      end

      private

      def assign_attributes
        self.class.defined_attributes&.each do |attr|
          instance_variable_set("@#{attr}", @attributes[attr])
        end
      end
    end
  end
end
