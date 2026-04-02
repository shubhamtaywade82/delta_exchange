# frozen_string_literal: true

require "dry-validation"

module DeltaExchange
  module Core
    class BaseModel
      include Helpers::AttributeHelper
      include Helpers::ValidationHelper

      attr_reader :raw_attributes, :errors

      def initialize(attributes = {}, skip_validation: false)
        @raw_attributes = normalize_keys(attributes)
        @errors = {}
        validate! unless skip_validation
        assign_attributes
      end

      # Expose raw_attributes as attributes for backward compatibility or clarity.
      def attributes
        @raw_attributes
      end

      class << self
        attr_reader :defined_attributes

        def attributes(*args)
          @defined_attributes ||= Set.new
          @defined_attributes.merge(args.map(&:to_s))
          args.each do |attr|
            define_method(attr) { @raw_attributes[attr] }
          end
          @defined_attributes.to_a
        end

        def build_from_response(response)
          payload = response.is_a?(Hash) && response.key?(:result) ? response[:result] : response
          return payload.map { |r| new(r, skip_validation: true) } if payload.is_a?(Array)

          new(payload, skip_validation: true)
        end
      end

      private

      def assign_attributes
        self.class.defined_attributes&.each do |attr|
          instance_variable_set("@#{attr}", @raw_attributes[attr])
        end
      end
    end
  end
end
