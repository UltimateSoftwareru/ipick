class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  private

  def jsonapi_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: permitted_params)
  end
end
