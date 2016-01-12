class DealsController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_courier!, only: [:create, :update]
  before_action :set_deal, only: [:show, :update]

  # GET /deals
  # GET /deals.json
  def index
    @deals = current_member.deals.in_status(params[:status])

    render json: @deals, include: [:order]
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
    render json: @deal, include: [:order]
  end

  # POST /deals
  # POST /deals.json
  def create
    @deal = current_courier.deals.new(jsonapi_params)

    if @deal.save
      render json: @deal, status: :created, location: @deal
    else
      render json: @deal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /deals/1
  # PATCH/PUT /deals/1.json
  def update
    if @deal.update(deal_update_params)
      handle_status_change if status_deal_param
      head :no_content
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
