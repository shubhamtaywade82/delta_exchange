# Authentication Details

DeltaExchange v2 uses a signature-based authentication method (HMAC-SHA256).

## Credentials Needed

1.  **API Key**: A unique key provided by Delta Exchange.
2.  **API Secret**: Used to sign requests (never share this!).

## Configuration Methods

### Block-style (Recommended for Initializers)

```ruby
DeltaExchange.configure do |config|
  config.api_key = ENV['DELTA_API_KEY']
  config.api_secret = ENV['DELTA_API_SECRET']
  config.testnet = true # Set to false for production
end
```

### Direct Initialization

You can also pass credentials directly when creating a client:

```ruby
client = DeltaExchange::Client.new(
  api_key: 'custom_key',
  api_secret: 'custom_secret',
  testnet: false
)
```

## Security Best Practices

*   **Environment Variables**: Never hardcode your API keys in the source code. Use gems like `dotenv` or Rails Credentials.
*   **IP Whitelisting**: For production, it is highly recommended to whitelist your server's IP in your Delta Exchange API settings.
*   **Permissions**: Only enable the permissions your bot needs (e.g., "Read" and "Trade"). Avoid "Withdrawal" permissions unless necessary.

## How the Gem Signs Requests

The gem handles signature generation automatically for every authenticated request. The pre-hash string follows the format:
`method + timestamp + path + query_string + payload`

Example internal logic:
```ruby
signature = OpenSSL::HMAC.hexdigest("SHA256", secret, prehash_string)
```
This is fully encapsulated in the `DeltaExchange::Auth` module.
