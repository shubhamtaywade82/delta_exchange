# Getting Started with DeltaExchange

DeltaExchange is a powerful Ruby gem designed for algorithmic trading on the Delta Exchange India platform. It provides a clean, model-based interface for REST API v2 and a real-time WebSocket client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'delta_exchange'
```

And then execute:

```bash
bundle install
```

## Basic Configuration

The gem needs to be configured with your API credentials. You can do this in an initializer (for Rails) or at the top of your script.

```ruby
require 'delta_exchange'

DeltaExchange.configure do |config|
  config.api_key = 'YOUR_API_KEY'
  config.api_secret = 'YOUR_API_SECRET'
  config.testnet = true # Use Delta Testnet for testing
end
```

## Quick Start Example

```ruby
# 1. Initialize the client
client = DeltaExchange::Client.new

# 2. Fetch all products
products = client.products.all

# 3. Find a specific product (e.g., BTCUSD perpetual)
btc_perp = products.find { |p| p[:symbol] == 'BTCUSD' }
puts "Trading #{btc_perp[:symbol]} with ID: #{btc_perp[:id]}"

# 4. Check your balance
balances = client.wallet.balances
puts "Available USDT: #{balances.find { |b| b[:asset_symbol] == 'USDT' }[:available_balance]}"

# 5. Place a limit order
order = client.orders.create(
  product_id: btc_perp[:id],
  size: 10,
  side: 'buy',
  order_type: 'limit_order',
  limit_price: '50000.0'
)
puts "Order placed! ID: #{order[:id]}"
```

## Next Steps

*   [Authentication Details](./AUTHENTICATION.md)
*   [REST API Guide](./REST_API_GUIDE.md)
*   [WebSocket Guide](./WEBSOCKET_GUIDE.md)
*   [Rails Integration](./RAILS_INTEGRATION.md)
*   [Standalone Ruby Guide](./STANDALONE_RUBY_GUIDE.md)
