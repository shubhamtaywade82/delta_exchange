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

```ruby
# Using singleton (after configure)
products = DeltaExchange.client.products.all

# Using direct client
client = DeltaExchange::Client.new

# Market Data
ticker = client.products.ticker('BTCUSD')

# Orders
order = client.orders.create({
  product_id: 1,
  size: 10,
  side: 'buy',
  order_type: 'limit_order',
  limit_price: '50000'
})

# Cancel all orders (accepts query parameters)
client.orders.cancel_all({ product_id: 1 })

# Account
balances = client.wallet.balances
profile = client.account.profile
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
