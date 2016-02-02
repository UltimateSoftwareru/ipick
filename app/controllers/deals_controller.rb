class DealsController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_courier!, only: [:create, :update]
  before_action :set_deal, only: [:show, :update]

  resource_description do
    desc "Deal is a middlerecord between order and courier, can be accepted, declined or delivered(if accepted)"
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  def_param_group :deal do
    param :data, Hash, desc: "Deal Data", required: true do
      param :attributes, Hash, desc: "Deal Attributes", required: true do
        param :status, Deal::STATUSES, desc: "Deal status"
      end
      param :relationships, Hash, desc: "Deal Relationships", required: true do
        param :order, Hash, desc: "Order Relationship" do
          param :type, String, desc: "Order type"
          param :id, Fixnum, desc: "Order id"
        end
      end
    end
  end

  api :GET, "deals", "all deals in status"
  desc "Path to render all deals in status, authorized for persons and couriers"
  param :status, Deal::STATUSES, desc: "Status to find deals, 'in_progress' by default"
  example self.multiple_example
  def index
    @deals = current_member.deals.in_status(params[:status] || Deal::IN_PROGRESS)

    render json: @deals, include: [:order]
  end

  api :GET, "deals/:id", "single deal"
  desc "Path to render single deal, authorized for persons and couriers"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Deal ID"
  example self.single_example
  def show
    render json: @deal, include: [:order]
  end

  api :POST, "deals", "create deal"
  desc "Path to create deal, authorized for couriers only"
  error 422, "Unprocessable entity"
  param_group :deal
  example self.single_example
  def create
    @deal = current_courier.deals.new(deal_update_params)

    if @deal.save
      render json: @deal, status: :created, location: @deal
    else
      render json: @deal.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, "deals/:id", "update deal"
  desc "Path to update deal, authorized for couriers only"
  error 404, "Record missing"
  error 422, "Unprocessable entity"
  param :id, Fixnum, desc: "Deal ID", required: true
  param_group :deal
  example self.single_example
  def update
    if @deal.update(deal_update_params)
      handle_status_change if status_deal_param
      render json: @deal, status: :ok
    else
      render json: @deal.errors, status: :unprocessable_entity
    end
  end

  private

  def set_deal
    @deal ||= current_member.deals.find(params[:id])
  end

  def deal_update_params
    jsonapi_params.except(:status)
  end

  def permitted_params
    %i(comment status order)
  end

  def status_deal_param
    jsonapi_params[:status]
  end

  def handle_status_change
    case status_deal_param.to_sym
    when Deal::DELIVERED
      @deal.deliver!
    end
  end
end
