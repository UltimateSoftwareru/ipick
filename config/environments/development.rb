Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  # config.action_mailer.delivery_method = :letter_opener
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true

  config.after_initialize do
    Bullet.enable = false
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
  config.action_mailer.default_url_options = {:host => 'ultimatesoftware.ru', :from => 'k.zenin@ultimatesoftware.ru'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.yandex.ru',
    port:                 587,
    domain:               'ultimatesoftware.ru',
    user_name:            'ultimatesoftware@yandex.ru',
    password:             'D9c-55y-y9F-Ar9',
    authentication:       'plain',
    enable_starttls_auto: true
  }
end
