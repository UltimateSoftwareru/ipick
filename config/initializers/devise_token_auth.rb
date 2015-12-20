DeviseTokenAuth.setup do |config|
  config.change_headers_on_each_request = false
  config.default_confirm_success_url = Rails.application.secrets.ui_host
  config.default_password_reset_url = Rails.application.secrets.ui_host + Rails.application.secrets.ui_password_path
end
