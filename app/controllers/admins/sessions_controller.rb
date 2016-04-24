class Admins::SessionsController < Devise::SessionsController
  self.responder = ApplicationResponder
  # respond_to :json, :html

  skip_before_action :verify_signed_out_user

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    redirect_to rails_admin_path
  end

  def respond_to_on_destroy
    redirect_to after_sign_out_path_for(resource_name)
  end
end
