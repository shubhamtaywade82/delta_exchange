# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Models::Position, :vcr do
  describe ".all" do
    it "fetches live testnet open derivatives positions natively" do
      positions = described_class.all
      
      expect(positions).to be_an(Array)
      expect(positions.first).to be_a(described_class) unless positions.empty?
    end
  end
end
