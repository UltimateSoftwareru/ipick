class Users::SessionsController < DeviseTokenAuth::SessionsController
  def create
    super do
      new_auth_header = @resource.create_new_auth_token(@client_id)
      response.headers.merge!(new_auth_header)
    end
  end
end
