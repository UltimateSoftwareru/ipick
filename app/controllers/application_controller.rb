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

  def self.single_example
    object_definitions.fetch(self.controller_path.to_sym) { {} }.fetch(:single) { {} }.to_s
  end

  def self.multiple_example
    object_definitions.fetch(self.controller_path.to_sym) { {} }.fetch(:multiple) { {} }.to_s
  end

  def self.object_definitions
    @@definitions ||= ObjectDefinitionsReader.process
  end
end
