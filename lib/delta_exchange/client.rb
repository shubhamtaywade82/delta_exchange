# frozen_string_literal: true

require "faraday"
require "json"
require "time"
require "uri"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/object/blank"

module DeltaExchange
  class Client
    attr_reader :root_url, :connection

    def initialize(api_key: nil, api_secret: nil, testnet: nil, base_url: nil)
      DeltaExchange.ensure_configuration!
      config = DeltaExchange.configuration
      @api_key = api_key || config.api_key
      @api_secret = api_secret || config.api_secret
      @testnet = testnet.nil? ? config.testnet : testnet
      @root_url = resolve_root_url(config, base_url)
      @connection = build_connection(@root_url, config)
    end

    def rebuild_connection!
      config = DeltaExchange.configuration
      @connection = build_connection(@root_url, config)
    end

    def request(method, path, payload = {}, params = {}, authenticate: true)
      ensure_credentials!(authenticate)
      timestamp = Time.now.to_i.to_s
      query_string = params.empty? ? "" : "?#{URI.encode_www_form(params)}"
      body = payload.empty? ? "" : payload.to_json

      headers = {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "User-Agent" => DeltaExchange.configuration.user_agent
      }

      if authenticate
        headers["api-key"] = @api_key
        headers["timestamp"] = timestamp
        headers["signature"] = Auth.sign(method, timestamp, path, query_string, body, @api_secret)
      end

      response = @connection.send(method) do |req|
        req.url "#{path}#{query_string}"
        req.headers.merge!(headers)
        req.body = body unless body.empty?
      end

      handle_response(response)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::SSLError => e
      raise(NetworkError.new(e.message).tap { |err| err.set_backtrace(e.backtrace) })
    end

    def get(path, params = {}, authenticate: true)
      request(:get, path, {}, params, authenticate: authenticate)
    end

    def post(path, payload = {}, authenticate: true)
      request(:post, path, payload, {}, authenticate: authenticate)
    end

    def put(path, payload = {}, authenticate: true)
      request(:put, path, payload, {}, authenticate: authenticate)
    end

    def patch(path, payload = {}, authenticate: true)
      request(:patch, path, payload, {}, authenticate: authenticate)
    end

    def delete(path, payload = {}, params = {}, authenticate: true)
      request(:delete, path, payload, params, authenticate: authenticate)
    end

    def products
      @products ||= Resources::Products.new(self)
    end

    def orders
      @orders ||= Resources::Orders.new(self)
    end

    def positions
      @positions ||= Resources::Positions.new(self)
    end

    def account
      @account ||= Resources::Account.new(self)
    end

    def wallet
      @wallet ||= Resources::Wallet.new(self)
    end

    def assets
      @assets ||= Resources::Assets.new(self)
    end

    def indices
      @indices ||= Resources::Indices.new(self)
    end

    def fills
      @fills ||= Resources::Fills.new(self)
    end

    def market_data
      @market_data ||= Resources::MarketData.new(self)
    end

    def heartbeat
      @heartbeat ||= Resources::Heartbeat.new(self)
    end

    private

    def ensure_credentials!(authenticate)
      return unless authenticate

      return if @api_key.present? && @api_secret.present?

      raise DeltaExchange::AuthenticationError, "api_key and api_secret are required for authenticated requests"
    end

    def resolve_root_url(config, explicit_base_url)
      return explicit_base_url if explicit_base_url.present?

      base = config.instance_variable_get(:@base_url)
      return base if base.present?

      @testnet ? DeltaExchange::Configuration::TESTNET_URL : DeltaExchange::Configuration::PRODUCTION_URL
    end

    def build_connection(url, config)
      Faraday.new(url: url) do |f|
        f.request :url_encoded
        f.response :logger, DeltaExchange.logger, headers: false, bodies: false if ENV["DELTA_DEBUG"] == "true"
        f.options.timeout = config.read_timeout
        f.options.open_timeout = config.connect_timeout
        f.options.write_timeout = config.write_timeout if f.options.respond_to?(:write_timeout=)
        f.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      body_str = response.body.to_s

      if response.status == 429
        retry_after = response.headers["X-RATE-LIMIT-RESET"]&.to_i
        raise DeltaExchange::RateLimitError.new(
          "Rate limited",
          retry_after_seconds: retry_after,
          response_body: parse_json_optional(body_str)
        )
      end

      if body_str.blank?
        raise DeltaExchange::Error, "API returned empty body (HTTP #{response.status})" unless response.success?

        return {}.with_indifferent_access
      end

      parsed_response = JSON.parse(body_str).with_indifferent_access

      return parsed_response if http_ok_without_api_failure?(response, parsed_response)

      raise DeltaExchange::ApiError.from_hash(parsed_response, status: response.status)
    rescue JSON::ParserError
      raise DeltaExchange::Error, "API returned non-JSON response (HTTP #{response.status}): #{body_str[0, 500]}"
    end

    def parse_json_optional(raw)
      return {}.with_indifferent_access if raw.blank?

      JSON.parse(raw).with_indifferent_access
    rescue JSON::ParserError
      { "raw" => raw }.with_indifferent_access
    end

    def http_ok_without_api_failure?(response, parsed_response)
      return false unless response.success?

      return parsed_response[:success] != false if parsed_response.key?(:success)

      true
    end
  end
end
