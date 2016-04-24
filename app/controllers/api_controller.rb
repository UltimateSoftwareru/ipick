class ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include PagerApi::Pagination::Kaminari

  resource_description do
    formats ["json", "jsonp"]
  end

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
    @@definitions ||= ObjectDefinitionsReader.read
  end

  def meta(collection, options = {})
    {
      per_page: options[:per_page].to_i || params[:per_page].to_i || ::Kaminari.config.default_per_page,
      total_pages: collection.total_pages,
      total_objects: collection.total_count,
      page: options[:page].to_i || params[:page].to_i
    }
  end
end
