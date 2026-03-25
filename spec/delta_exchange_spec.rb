# frozen_string_literal: true

RSpec.describe DeltaExchange do
  it "has a version number" do
    expect(DeltaExchange::VERSION).not_to be_nil
  end

  it "loads the client" do
    expect { DeltaExchange::Client.new }.not_to raise_error
  end
end
