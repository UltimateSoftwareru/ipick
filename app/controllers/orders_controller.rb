class OrdersController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_person!, only: [:create, :update, :destroy]
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    status = params[:status]
    @orders = if current_courier && status.to_sym == Order::OPENED
                Order.in_status(status.to_sym).open_for(current_courier.id)
              else
                current_member.orders.in_status(status.to_sym)
              end

    render json: @orders, include: [:deals, :assigned_deal]
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    render json: @order, include: [:deals, :assigned_deal]
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_person.orders.new(order_params)

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    if @order.update(order_params)
      handle_status_change if status_order_param
      head :no_content
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy

    head :no_content
  end

  private

  def set_order
    @order ||= current_member.orders.find(params[:id])
  end

  def order_params
    jsonapi_params.except(:status)
  end

  def permitted_params
    %i(name status description photo_confirm
       value price weight delivery_estimate
       grab_from grab_to deliver_from deliver_to)
  end

  def status_order_param
    jsonapi_params[:status]
  end

  def handle_status_change
    case status_order_param.to_sym
    when Order::CLOSED
      @order.close!
    when Order::OPENED
      return if @order.opened?
      @order.reopen!
    end
  end
end
