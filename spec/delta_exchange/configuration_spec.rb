# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeltaExchange::Configuration do
  describe "defaults" do
    it "sets base parameters perfectly" do
      config = described_class.new

      expect(config.testnet).to be false
      expect(config.connect_timeout).to eq(10)
      expect(config.read_timeout).to eq(30)
      expect(config.base_url).to eq(DeltaExchange::Configuration::PRODUCTION_URL)
    end
  end

  describe "DeltaExchange global configuration block" do
    it "allocates configuration globally across the singleton" do
      DeltaExchange.configure do |c|
        c.testnet = true
        c.connect_timeout = 5
      end

      expect(DeltaExchange.configuration.testnet).to be true
      expect(DeltaExchange.configuration.connect_timeout).to eq(5)
    end
  end
end
