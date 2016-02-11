class AddressesController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier]
  before_action :authenticate_member!, only: [:show]
  before_action :authenticate_person!, only: [:index, :create, :update, :destroy]
  before_action :load_address, only: [:update, :destroy]

  resource_description do
    desc "Addresses represents a records with geopositional points on the map provided by latitude and longitude"
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  def_param_group :address do
    param :data, Hash, desc: "Address Data", required: true do
      param :attributes, Hash, desc: "Record Attributes", action_aware: true, required: true do
        param :latitude, Float, desc: "Address latitude", required: true
        param :longitude, Float, desc: "Address longitude", required: true
        param :name, String, desc: "Address person name"
        param :phone, String, desc: "Address person mobile phone number"
      end
    end
  end

  api :GET, "addresses", "all persons addresses"
  desc "Path to render all persons addresses, authorized for person only"
  example self.multiple_example
  def index
    @addresses = current_person.addresses

    render json: @addresses, includes: includes
  end

  api :GET, "addresses/:id", "single address"
  desc "Path to render single address, authorized for person and courier"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Address ID"
  example self.single_example
  def show
    render json: Address.find(params[:id]), includes: includes
  end

  api :POST, "addresses", "create address"
  desc "Path to create address, authorized for person only"
  error 422, "Unprocessable entity - {\"latitude\":[\"can't be blank\"]}"
  param_group :address
  example self.single_example
  def create
    @address = current_person.addresses.new(jsonapi_params)

    if @address.save
      render json: @address, status: :created, includes: includes
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, "addresses/:id", "update address"
  desc "Path to update address, authorized for person only"
  error 404, "Record missing"
  error 422, "Unprocessable entity - {\"latitude\":[\"can't be blank\"]}"
  param :id, Fixnum, desc: "Address ID", required: true
  param_group :address
  example self.single_example
  def update
    if @address.update(jsonapi_params)
      render json: @address, status: :ok, includes: includes
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "addresses/:id", "delete address"
  desc "Path to delete address, authorized for person only"
  error 404, "Record missing"
  param :id, Fixnum, desc: "Address ID", required: true
  example "204 No Content"
  def destroy
    @address.destroy

    head :no_content
  end

  private

  def load_address
    @address ||= current_person.addresses.find(params[:id])
  end

  def permitted_params
    %i(latitude longitude name phone)
  end

  def includes
    %i(person order)
  end
end
