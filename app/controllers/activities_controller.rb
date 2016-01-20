class ActivitiesController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :load_courier, only: [:index, :show]

  resource_description do
    desc "Activity represents a history when courier was in active status"
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  api :GET, "activities", "all activities"
  desc "Path to render all activities, authorized for persons, couriers and operators"
  param :courier_id, Fixnum, desc: "Courier ID, required if authorized operator or person"
  example self.multiple_example
  def index
    @activities = @courier.activities

    render json: @activities
  end

  api :GET, "activities/:id", "single activity"
  desc "Path to render single activity, authorized for persons, couriers and operators"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Activity ID"
  param :courier_id, Fixnum, desc: "Courier ID, required if authorized operator or person"
  example self.single_example
  def show
    @activity ||= @courier.activities.find_by(id: params[:id])

    render json: @activity
  end

  private

  def load_courier
    @courier ||= current_courier || Courier.find_by(id: params[:courier_id])
  end
end
