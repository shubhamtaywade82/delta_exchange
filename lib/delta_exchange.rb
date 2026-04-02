# frozen_string_literal: true

require "zeitwerk"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/object/blank"
require "logger"

module DeltaExchange
  loader = Zeitwerk::Loader.for_gem
  loader.setup

  require_relative "delta_exchange/error"

  class << self
    attr_writer :configuration, :logger

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
      self.logger ||= Logger.new($stdout, level: Logger::INFO)
    end

    def logger
      @logger ||= Logger.new($stdout, level: Logger::INFO)
    end

    def ensure_configuration!
      self.configuration ||= Configuration.new
    end

    def reset!
      @configuration = Configuration.new
    end
  end
end
