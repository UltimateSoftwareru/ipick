class TransportsController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  before_action :authenticate_member!, only: [:index, :show]

  resource_description do
    desc "Transport represents a records of available transports"
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  api :GET, "transports", "all transports"
  desc "Path to render all transports in status, authorized for persons, couriers and operators"
  example self.multiple_example
  def index
    @transports = Transport.all

    render json: @transports, includes: includes
  end

  api :GET, "transports/:id", "single transport"
  desc "Path to render single transport, authorized for persons, couriers and operators"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Complain ID"
  example self.single_example
  def show
    @transport ||= Transport.find_by(id: params[:id])

    render json: @transport, includes: includes
  end

  private

  def includes
    %i(orders)
  end
end
