# WebSocket Guide

DeltaExchange WebSocket API v2 provides real-time streaming for public market data and private user updates.

## Basic Usage

The WebSocket client runs in a background thread using `EventMachine`.

```ruby
ws = DeltaExchange::Websocket::Client.new

# Handle public updates
ws.on :message do |data|
  case data['type']
  when 'v2/ticker'
    puts "Price update: #{data['symbol']} is now #{data['last_price']}"
  when 'l2_updates'
    puts "Orderbook update for #{data['symbol']}"
  end
end

# Handle specific events
ws.on :open do
  puts "WebSocket Connected!"
  
  # Subscribe to channels
  ws.subscribe([
    { name: "v2/ticker", symbols: ["BTCUSD", "ETHUSD"] },
    { name: "l2_updates", symbols: ["BTCUSD"] }
  ])
end

ws.connect!

# Keep the main process alive (only needed for standalone scripts)
loop { sleep 1 }
```

## Private Channels

If you provide an `api_key` and `api_secret`, the gem automatically handles authentication upon connection.

```ruby
# The gem will use global configuration if not passed explicitly
ws = DeltaExchange::Websocket::Client.new

ws.on :open do
  # Authenticated! Now subscribe to private data
  ws.subscribe([
    { name: "orders" },
    { name: "positions" },
    { name: "margins" }
  ])
end

ws.on :message do |data|
  if data['type'] == 'orders'
    puts "Order status changed! New status: #{data['status']}"
  end
end

ws.connect!
```

## Available Channels

### Public
- `v2/ticker`: Live price and 24h stats.
- `l1_orderbook`: Top of the book.
- `l2_orderbook`: Full order book (snapshot).
- `l2_updates`: Incremental order book updates.
- `all_trades`: Live public trade stream.
- `mark_price`: Current mark price for perpetuals.
- `candlesticks`: Live OHLCV candle updates.
- `spot_price`: Current index spot price.

### Private (Auth Required)
- `orders`: Personal order fill and status updates.
- `positions`: Personal position change updates.
- `user_trades`: Personal execution stream.
- `margins`: Personal margin balance updates.

## Performance Notes

*   **EM Reactor**: The gem starts an EventMachine reactor in a background thread. This means it won't block your main application (like a Rails server).
*   **JSON Parsing**: Every message is parsed into a Ruby Hash automatically.
*   **Reconnection**: The gem includes internal logic to attempt reconnection if the socket drops.

## Advanced: Persistence and Caching

In a production trading application, you often need to access the "Last Traded Price" (LTP) from different parts of your application (e.g., a Rails controller or a background job) without maintaining a constant WebSocket connection in every process.

The best practice is to use a centralized store like **Redis** or **Rails Cache**.

### 1. Storing Ticks in Redis

Using Redis allows multiple processes to read the latest price instantly.

```ruby
require 'redis'
redis = Redis.new

ws = DeltaExchange::Websocket::Client.new

ws.on :message do |data|
  if data['type'] == 'v2/ticker'
    symbol = data['symbol']
    price = data['last_price']
    
    # Store the latest price in Redis with an optional TTL
    redis.set("delta:ltp:#{symbol}", price)
    
    # Optionally store the full tick as JSON
    redis.set("delta:tick:#{symbol}", data.to_json)
  end
end

ws.connect!
```

### 2. Storing Ticks in Rails Cache

If you are using Rails, you can utilize the built-in cache (which often uses Redis as a backend).

```ruby
# Inside your WebSocket worker/task
ws.on :message do |data|
  if data['type'] == 'v2/ticker'
    Rails.cache.write("delta_ltp_#{data['symbol']}", data['last_price'])
  end
end
```

### 3. Accessing LTP from a Controller

Once stored, you can access the data from anywhere in your Rails app:

```ruby
class TradesController < ApplicationController
  def current_price
    # Fast read from cache/redis
    price = Rails.cache.read("delta_ltp_#{params[:symbol]}")
    
    render json: { symbol: params[:symbol], price: price }
  end
end
```

### 4. Background Job Pattern

For complex bots, use the WebSocket to trigger background jobs for execution:

```ruby
ws.on :message do |data|
  if data['type'] == 'v2/ticker' && data['last_price'].to_f > 60000.0
    # Trigger a trade job if price threshold met
    TradeExecutionJob.perform_later('BTCUSD', 'sell', data['last_price'])
  end
end
```
