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
