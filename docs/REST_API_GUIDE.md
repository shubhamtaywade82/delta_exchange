# REST API Guide

DeltaExchange REST API v2 follows standard JSON patterns. The gem exposes resources through the `Client` object.

## Initializing the Client

```ruby
client = DeltaExchange::Client.new
```

## Resources

### Products

Provides data about tradable instruments.

```ruby
products = client.products.all
symbol_data = client.products.find('BTCUSD')
tickers = client.products.tickers
single_ticker = client.products.ticker('BTCUSD')
leverage_data = client.products.leverage(1) # For product_id: 1
client.products.set_leverage(1, leverage: "25")
```

### Orders

Execution management.

```ruby
# Create a limit order
order = client.orders.create(
  product_id: 1,
  size: 10,
  side: 'buy',
  order_type: 'limit_order',
  limit_price: '50000.0'
)

# Edit an order
client.orders.update(
  id: order[:id],
  product_id: 1,
  size: 12,
  limit_price: '50100.0'
)

# Cancel an order
client.orders.cancel(id: order[:id], product_id: 1)

# Cancel all orders
client.orders.cancel_all(product_id: 1) # Optional product filter

# Batch orders (up to 50 in one call)
client.orders.create_batch(
  product_id: 1,
  orders: [
    { size: 5, side: 'buy', order_type: 'limit_order', limit_price: '49000.0' },
    { size: 5, side: 'buy', order_type: 'limit_order', limit_price: '48000.0' }
  ]
)
```

### Positions

Margin and leverage tracking.

```ruby
# Fetch all open positions
positions = client.positions.all

# Change leverage for an open position
client.positions.change_leverage(product_id: 1, leverage: "50")

# Adjust margin (add/remove)
client.positions.adjust_margin(product_id: 1, amount: "100.0", type: "add")

# Close all positions
client.positions.close_all
```

### Market Data

Historical and statistical information.

```ruby
# Get order book (Level 2)
book = client.market_data.l2_orderbook('BTCUSD')

# Get recent trades
trades = client.market_data.trades('BTCUSD')

# Get candles (OHLCV)
candles = client.market_data.candles(
  product_id: 1,
  resolution: '1m',
  start_time: (Time.now - 3600).to_i,
  end_time: Time.now.to_i
)

# Get specialized data
funding = client.market_data.funding_rates(product_id: 1)
oi = client.market_data.open_interest(product_id: 1)
```

### Wallet

Account balances and history.

```ruby
balances = client.wallet.balances
history = client.wallet.transactions
deposits = client.wallet.deposits
withdrawals = client.wallet.withdrawals

# Sub-account balance transfer
client.wallet.subaccount_transfer(
  asset_id: 1, # USDT
  amount: "500.0",
  sub_account_id: 1234,
  method: "deposit" # deposit into sub-account
)
```

### Account

User-level configuration and statistics.

```ruby
profile = client.account.profile
fee_tiers = client.account.fee_tiers
referrals = client.account.referrals
client.account.update_trading_preferences(order_confirmation: false)
```

## Error Handling

Standardized API and validation errors.

```ruby
begin
  client.orders.create(size: 0) # This will fail validation
rescue DeltaExchange::ValidationError => e
  puts "Check your inputs: #{e.message}"
rescue DeltaExchange::RateLimitError => e
  puts "Slowing down! Retry after #{e.retry_after_ms}ms"
rescue DeltaExchange::ApiError => e
  puts "API Error: #{e.message} (Code: #{e.code})"
end
```
