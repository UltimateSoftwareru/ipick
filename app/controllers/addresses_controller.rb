class AddressesController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier]
  before_action :authenticate_member!, only: [:show]
  before_action :authenticate_person!, only: [:index, :create, :update, :destroy]
  before_action :load_address, only: [:update, :destroy]

  # GET /addresses
  # GET /addresses.json
  def index
    @addresses = current_person.addresses

    render json: @addresses
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
    render json: Address.find(params[:id])
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = current_person.addresses.new(jsonapi_params)

    if @address.save
      render json: @address, status: :created, location: @address
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    if @address.update(jsonapi_params)
      render json: @address, status: :ok, location: @address
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy

    head :no_content
  end

  private

  def load_address
    @address ||= current_person.addresses.find(params[:id])
  end

  def permitted_params
    %i(latitude longitude address name phone address)
  end
end
