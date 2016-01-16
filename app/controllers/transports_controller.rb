class TransportsController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  before_action :authenticate_member!, only: [:index]

  # GET /transports
  # GET /transports.json
  def index
    @transports = Transport.all

    render json: @transports
  end
end
