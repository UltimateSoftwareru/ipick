class UsersController < ApplicationController
  before_action :set_current_resource, only: [:me, :update]
  before_action :set_resource, only: :show

  resource_description do
    desc "User login routes"
    formats ["json"]
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  api :POST, 'auth/sign_in', "any resource sign in route"
  param :email,  String, desc: "Resource email", required: true
  param :password, String,  desc: "Resource password", required: true
  error 401, "Unauthorized - \"errors\": [\"Invalid login credentials. Please try again.\"]"
  example self.single_example +
    "\nHeaders (Access Token, Client, Uid) which should be included in all next authorized request"
  def sign_in
    raise "Do not use, just a stub for apidoc"
  end

  api :POST, "auth/password", "resource change password request"
  param :email,  String, desc: "Resource email", required: true
  error 401, <<-DESC
    Unauthorized - {"status":"error",
                    "errors":{"email":["can't be blank","is not an email"],
                    "full_messages":["Email can't be blank","Email is not an email"]}}
  DESC
  example <<-DESC
    Call sends email message with link like below
    BACKEND_HOST/auth/password/edit?config=default&redirect_url=FRONTEND_HOST/password&reset_password_token=reset_password_token
  DESC
  def password
    raise "Do not use, just a stub for apidoc"
  end

  api :POST, "{{resource}}/auth", "register as resource, resource includes in ['people', 'couriers', 'operators']"
  param :email,  String, desc: "Resource email", required: true
  param :password, String,  desc: "Resource password", required: true
  param :password_confirmation, String,  desc: "Resource password confirmation", required: true
  error 401, "Unauthorized - {\"success\":false,\"errors\":[\"You must provide an email address.\"]}"
  example <<-DESC
    Call sends email message with link like below
    BACKEND_HOST/auth/confirmation?config=default&confirmation_token=confirmation_token&redirect_url=FRONTEND_HOST
  DESC
  def sign_up
    raise "Do not use, just a stub for apidoc"
  end
end
