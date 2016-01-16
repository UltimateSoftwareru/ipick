class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  private

  def permitted_polymorphic
    []
  end

  def permitted_params
    []
  end

  def jsonapi_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params,
      only: permitted_params,
      polymorphic: permitted_polymorphic)
  end
end
