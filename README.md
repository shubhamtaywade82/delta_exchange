# DeltaExchange

A Ruby client for the Delta Exchange API.

**Requirement**: Ruby >= 3.2.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'delta_exchange'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install delta_exchange

## Usage

### Configuration

```ruby
DeltaExchange.configure do |config|
  config.api_key = ENV['DELTA_API_KEY'] || 'YOUR_API_KEY'
  config.api_secret = ENV['DELTA_API_SECRET'] || 'YOUR_API_SECRET'
  config.testnet = true # Optional, defaults to false
end
```

**Note:** If you are testing the client via `./bin/console`, it will automatically load any variables from a `.env` file in the root directory into `ENV`.

### REST API

The client can be used by instantiating `DeltaExchange::Client.new` or you can rely on the singleton module accessory directly. Note: All resource methods return a Hash with indifferent access (keys can be accessed as strings or symbols).

#### 1. Products & Market Data
Retrieve available trading pairs, orderbooks, and option chains.
```ruby
# Get all products
client.products.all

# Get ticker for a specific symbol
client.products.ticker('BTCUSD')

# Get L2 orderbook
client.products.l2_orderbook('BTCUSD')

# Get an option chain layout
client.products.get_option_chain(asset_id: 2, expiration: '2024-12-27')

# Get historical candlestick data
client.market_data.history(symbol: 'BTCUSD', resolution: '1d', start_time: 1672531200, end_time: 1675123200)

# Track system heartbeat
client.heartbeat.check
```

#### 2. Orders
Create, manage, and cancel active orders.
```ruby
# Create a new order
client.orders.create({
  product_id: 1,
  size: 10,
  side: 'buy',
  order_type: 'limit_order',
  limit_price: '50000'
})

# Get a specific order by ID
client.orders.get(order_id: 12345)

# List all active orders
client.orders.all

# Cancel a specific order
client.orders.cancel(order_id: 12345)

# Cancel all open orders for a product
client.orders.cancel_all({ product_id: 1 })

# Interactively change leverage for a product
client.orders.change_leverage(product_id: 1, leverage: 50)
```

#### 3. Positions & Fills
Track open derivatives positions and execution histories.
```ruby
# Get all open positions
client.positions.all

# Update margin on an isolated position
client.positions.update_margin(product_id: 1, margin: '150.5')

# Auto top-up margin
client.positions.auto_topup(product_id: 1, auto_topup: true)

# Retrieve recent trade fills
client.fills.all(product_id: 1, limit: 50)
```

#### 4. Account & Wallet
Monitor balances and configure account-level preferences.
```ruby
# Get wallet balances across all assets
client.wallet.balances

# List recent wallet transactions
client.wallet.transactions

# View user profile details
client.account.profile

# Update trading preferences
client.account.trading_preferences(cancel_on_disconnect: true)
```

#### 5. Assets & Indices
Pull infrastructure parameters mapping indices to component assets.
```ruby
# Get all platform assets
client.assets.all

# Get all tracked indices
client.indices.all
```

### Error Handling

The gem wraps network and API responses within native Ruby classes.

```ruby
begin
  client.orders.create({ product_id: 999999, size: 10 })
rescue DeltaExchange::RateLimitError => e
  puts "Rate limited! Retry after #{e.retry_after_seconds} seconds"
rescue DeltaExchange::ApiError => e
  puts "API rejected the request: #{e.message} (Code: #{e.code})"
rescue DeltaExchange::NetworkError => e
  puts "Could not connect: #{e.message}"
end
```

### WebSocket

Note: The WebSocket client uses EventMachine in a detached thread. Reconnections must be handled explicitly by the consumer if the connection drops.

```ruby
ws = DeltaExchange::Websocket::Client.new

ws.on :open do |event|
  puts "Connected!"
  ws.subscribe([
    { name: "v2/ticker", symbols: ["BTCUSD"] }
  ])
end

ws.on :message do |data|
  puts "Received: #{data}"
end

ws.connect!

# Keep the main thread alive if necessary
loop { sleep 1 }
```

## Debugging

You can enable HTTP traffic logging via the command-line environment variables. 
The API key header is automatically suppressed during debug rendering to protect credentials.

```bash
DELTA_DEBUG=true ruby app.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shubham-taywade/delta-exchange.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
