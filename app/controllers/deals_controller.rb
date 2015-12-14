class DealsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :courier]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_courier!, only: [:update]
  before_action :set_deal, only: [:show, :update, :destroy]

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

  # PATCH/PUT /deals/1
  # PATCH/PUT /deals/1.json
  def update
    if @deal.update(deal_params)
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

  def deal_params
    params.require(:data)
          .require(:attributes)
          .permit(:comment)
  end

  def status_deal_param
    params.require(:data)
          .require(:attributes)
          .permit(:status)[:status]
  end

  def handle_status_change
    case status_deal_param.to_sym
    when Deal::IN_PROGRESS
      @deal.accept!
    when Deal::DECLINED
      @deal.decline!
    when Deal::DELIVERED
      @deal.deliver!
    end
  end
end
