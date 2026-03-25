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

## Step 6: Caching Real-time Data (Redis/Rails Cache)

For high-frequency data like LTP (Last Traded Price), you typically want to store the latest value in a fast cache so that your controllers, models, or other background jobs can access it instantly without hitting the database.

### Using Rails.cache

```ruby
# inside the rake task's :message block
if data['type'] == 'v2/ticker'
  Rails.cache.write("ltp:#{data['symbol']}", data['last_price'])
end

# accessing it anywhere else in Rails
ltp = Rails.cache.read("ltp:BTCUSD")
```

### Using Redis Directly (Recommended for Performance)

If you have a dedicated Redis instance for market data:

```ruby
# inside the rake task's :message block
$redis.hset("delta:ltp", data['symbol'], data['last_price'])

# accessing it elsewhere
ltp = $redis.hget("delta:ltp", "BTCUSD")
```

### Pattern: Fetcher Helper

It's common to create a helper in your `MarketPrice` model or a specific service:

```ruby
class MarketPrice
  def self.ltp(symbol)
    Rails.cache.read("ltp:#{symbol}") || DeltaExchange::Models::Ticker.find(symbol)&.last_price
  end
end
```
