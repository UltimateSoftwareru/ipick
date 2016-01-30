require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Ipick
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: Rails.application.secrets.url }
    config.active_record.raise_in_transactional_callbacks = true
    config.i18n.available_locales = :ru
    config.i18n.default_locale = :ru

    config.autoload_paths += ["#{config.root}/app/models/users/", "#{config.root}/app/controllers/users/"]
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
    config.paperclip_defaults = {
      :storage => :s3,
      :bucket => Rails.application.secrets.aws_config['bucket']
    }
  end
end
