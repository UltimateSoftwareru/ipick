class TransportsController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  before_action :authenticate_member!, only: [:index, :show]

  # GET /transports
  # GET /transports.json
  def index
    @transports = Transport.all

    render json: @transports
  end

  # GET /transports/1
  # GET /transports/1.json
  def show
    @transport ||= Transport.find_by(id: params[:id])

    render json: @transport
  end
end
