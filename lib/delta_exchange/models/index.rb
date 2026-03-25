# frozen_string_literal: true

module DeltaExchange
  module Models
    class Index < Core::BaseModel
      attributes :id, :symbol, :description, :constituent_exchanges, :price_method, :is_composite

      class << self
        def resource
          @resource ||= DeltaExchange::Resources::Indices.new
        end

        def all
          build_from_response(resource.all)
        end

        def find(symbol)
          build_from_response(resource.find(symbol))
        end
      end
    end
  end
end
