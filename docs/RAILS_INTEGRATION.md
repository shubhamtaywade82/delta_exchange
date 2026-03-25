# Rails Integration Guide

Integrating the DeltaExchange gem into a Rails application is simple.

## Step 1: Add the Gem

Add the gem to your `Gemfile`:

```ruby
gem 'delta_exchange'
```

And run:

```bash
bundle install
```

## Step 2: Configure with Initializer

Create `config/initializers/delta_exchange.rb`:

```ruby
# frozen_string_literal: true

DeltaExchange.configure do |config|
  config.api_key = Rails.application.credentials.dig(:delta, :api_key)
  config.api_secret = Rails.application.credentials.dig(:delta, :api_secret)
  config.testnet = Rails.env.development? || Rails.env.test?
end
```

## Step 3: Use in Models or Services

For best practices, wrap the client in a service class:

```ruby
# app/services/trading_service.rb
class TradingService
  def initialize
    @client = DeltaExchange::Client.new
  end

  def place_btc_limit_order(price, size)
    @client.orders.create(
      product_id: 1, # BTCUSD
      size: size,
      side: 'buy',
      order_type: 'limit_order',
      limit_price: price.to_s
    )
  end
end
```

## Step 4: Background Jobs for WebSocket

Since WebSockets need a persistent connection, it's best to run them in a separate process. You can use a custom rake task or a background job (like Sidekiq) to manage the stream.

**Example Rake Task (`lib/tasks/trading.rake`):**

```ruby
namespace :trading do
  desc "Start the Delta Exchange WebSocket stream"
  task stream: :environment do
    ws = DeltaExchange::Websocket::Client.new
    
    ws.on :message do |data|
      # Handle live updates and maybe update your database
      if data['type'] == 'v2/ticker'
        MarketPrice.update_price(data['symbol'], data['last_price'])
      end
    end

    ws.on :open do
      puts "Market stream active..."
      ws.subscribe([{ name: "v2/ticker", symbols: ["BTCUSD"] }])
    end

    ws.connect!
    
    # Keep the task alive
    loop { sleep 1 }
  end
end
```

## Step 5: Real-time UI with ActionCable

You can broadcast the incoming WebSocket data from the Rake task to your frontend using Rails ActionCable:

```ruby
# inside the rake task's :message block
ActionCable.server.broadcast('price_channel', { symbol: data['symbol'], price: data['last_price'] })
```
