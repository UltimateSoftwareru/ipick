require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Ipick
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.middleware.insert_before 0, "Rack::Cors", debug: true, logger: (-> { Rails.logger }) do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          credentials: true,
          methods: [:get, :post, :delete, :put, :patch, :options, :head],
          expose: ["access-token", "expiry", "token-type", "uid", "client"],
          max_age: 0
      end
    end
  end
end
