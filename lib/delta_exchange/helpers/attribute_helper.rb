# frozen_string_literal: true

require "active_support/core_ext/string/inflections"
require "active_support/core_ext/hash/keys"

module DeltaExchange
  module Helpers
    module AttributeHelper
      def camelize_keys(hash)
        hash.transform_keys { |key| key.to_s.camelize(:lower) }
      end

      def snake_case_keys(hash)
        hash.transform_keys { |key| key.to_s.underscore.to_sym }
      end

      def normalize_keys(hash)
        hash.transform_keys { |k| k.to_s.underscore }.with_indifferent_access
      end
    end
  end
end
