require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Ipick
  class Application < Rails::Application
    config.app_generators.scaffold_controller :responders_controller

    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Cookies

    config.action_mailer.default_url_options = { host: Rails.application.secrets.url }
    config.active_record.raise_in_transactional_callbacks = true
    config.i18n.available_locales = [:ru, :en]
    config.i18n.default_locale = :ru

    config.api_only = false
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
    config.action_mailer.default_url_options = {
      :host => 'http://54.165.254.9/',
      :from => 'kos.zenin.rails@gmail.com'
    }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'gmail.com',
      user_name:            'kos.zenin.rails@gmail.com',
      password:             '37atrchpo',
      authentication:       'plain',
      enable_starttls_auto: true
    }
  end
end
