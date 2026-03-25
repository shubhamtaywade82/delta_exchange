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

The client employs a highly robust **ActiveRecord**-style abstraction via the `DeltaExchange::Models::` namespace. Rather than interacting with raw unstructured JSON payloads via `Client.new`, you query the platform utilizing structured properties and class-level queries. 

#### 1. Products & Market Data
Retrieve available trading pairs, orderbooks, and option chains natively.
```ruby
# Get all products (returns array of Models::Product)
DeltaExchange::Models::Product.all

# Get a specific product by symbol
product = DeltaExchange::Models::Product.find('BTCUSD')
puts product.contract_type # "perpetual_futures"

# Get all live tickers
DeltaExchange::Models::Ticker.all

# Leverage interactions are natively mapped
product.set_leverage(50)
```

#### 2. Orders
Create, manage, and cancel your active orders.
```ruby
# Create a new order (Returns a Models::Order)
order = DeltaExchange::Models::Order.create({
  product_id: 1,
  size: 10,
  side: 'buy',
  order_type: 'limit_order',
  limit_price: '50000'
})

# Access properties
puts order.status # "open"

# List your active orders
DeltaExchange::Models::Order.all

# Cancel the order directly from its instance
order.cancel
```

#### 3. Positions & Fills
Track open derivatives positions and execution histories cleanly.
```ruby
# Get all open positions
DeltaExchange::Models::Position.all

# Find an isolated position by Product ID
position = DeltaExchange::Models::Position.find(1)

# Modify your isolated positions natively
position.adjust_margin('150.5', type: 'add')
position.set_auto_topup(true)

# Retrieve recent trade fills (Returns an array of Models::Fill)
DeltaExchange::Models::Fill.all(product_id: 1, limit: 50)
```

#### 4. Account & Wallet
Monitor balances and configure account-level preferences.
```ruby
# Get wallet balances across all assets
DeltaExchange::Models::WalletBalance.all

# Isolate a specific currency balance
btc_balance = DeltaExchange::Models::WalletBalance.find_by_asset('BTC')

# List recent wallet transactions
DeltaExchange::Models::WalletTransaction.all

# View your user profile details
profile = DeltaExchange::Models::Profile.fetch
puts profile.kyc_status

# Update trading preferences natively
prefs = DeltaExchange::Models::TradingPreferences.fetch
prefs.update(cancel_on_disconnect: true)
```

#### 5. Assets & Indices
Pull infrastructure parameters mapping indices to component assets.
```ruby
# Get all platform assets
DeltaExchange::Models::Asset.all

# Get all tracked indices
DeltaExchange::Models::Index.all
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
