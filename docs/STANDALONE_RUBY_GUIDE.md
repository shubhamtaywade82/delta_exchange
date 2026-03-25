# Standalone Ruby Script Guide

The DeltaExchange gem can be used in any Ruby environment, from simple CLI scripts to powerful trading bots.

## Script Structure

```ruby
# frozen_string_literal: true

require 'bundler/inline'

# 1. Inline gem dependency (no need for a Gemfile)
gemfile do
  source 'https://rubygems.org'
  gem 'delta_exchange'
  gem 'dotenv' # for loading credentials from .env
end

require 'delta_exchange'
require 'dotenv/load'

# 2. Configure the client
DeltaExchange.configure do |config|
  config.api_key = ENV['DELTA_API_KEY']
  config.api_secret = ENV['DELTA_API_SECRET']
  config.testnet = true
end

# 3. Business logic
def run_trading_loop
  client = DeltaExchange::Client.new
  
  loop do
    ticker = client.products.ticker('BTCUSD')
    puts "BTC Price: #{ticker[:last_price]}"
    
    # Place your automated trading strategy here...
    
    sleep 10 # Wait 10 seconds before next check
  end
rescue Interrupt
  puts "\nStopping bot..."
end

run_trading_loop
```

## Running with `.env` file

Create a file named `.env` in the same directory as your script:

```bash
DELTA_API_KEY=your_actual_key
DELTA_API_SECRET=your_actual_secret
DELTA_TESTNET=true
```

## Using as a CLI Tool

The gem includes a console for interactive use:

```bash
# From the project root
bin/console
```

Once inside, you can interact with the API directly:

```ruby
irb(main):001> client = DeltaExchange::Client.new
irb(main):002> client.products.all.first[:symbol]
=> "BTCUSD"
```
