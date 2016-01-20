Apipie.configure do |config|
  config.app_name                = "Ipick"
  config.api_base_url            = "/"
  config.doc_base_url            = "/apidoc"
  config.api_controllers_matcher = ["#{Rails.root}/app/controllers/**/*.rb"]
  config.validate = false
  config.reload_controllers = Rails.env.development?
  config.api_routes = Rails.application.routes
  config.app_info["1.0"] = "Amazing iPick API docs"
  config.authenticate = Proc.new do
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.secrets.apidoc_username && password == Rails.application.secrets.apidoc_password
    end
  end
end

class Apipie::Application
  alias_method :orig_load_controller_from_file, :load_controller_from_file
  def load_controller_from_file(controller_file)
    orig_load_controller_from_file(controller_file.gsub("users/", ""))
  end
end
