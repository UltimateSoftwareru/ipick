class OrdersController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  devise_token_auth_group :orderer, contains: [:person, :courier]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_person!, only: [:create]
  before_action :authenticate_orderer!, only: [:update]
  before_action :set_order, only: [:update]

  resource_description do
    desc "Order is a person proposal to deliver something somewhere"
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  def_param_group :order do
    param :data, Hash, desc: "Order Data", required: true do
      param :attributes, Hash, desc: "Order Attributes", action_aware: true, required: true do
        param :name, String, desc: "Order name"
        param :description, String, desc: "Order description"
        param :status, Order::STATUSES, desc: "Order status"
        param :price, Fixnum, desc: "Order price"
        param :weight, Fixnum, desc: "Order weight"
        param :grab_from, Time, desc: "Start time order should be grabbed by courier"
        param :grab_to, Time, desc: "End time order should be grabbed by courier"
        param :deliver_from, Time, desc: "Start time order should be delivered by courier"
        param :deliver_to, Time, desc: "End time order should be delivered by courier"
      end
      param :relationships, Hash, desc: "Order Relationships", required: true do
        param :from_address, Hash, desc: "From Address Relationship", required: true do
          param :latitude, Float, desc: "Address latitude", required: true
          param :longitude, Float, desc: "Address longitude", required: true
          param :name, String, desc: "Address person name"
          param :phone, String, desc: "Address person mobile phone number"
        end
        param :addresses, Array, desc: "Array of destination addresses Relationship", required: true do
          param :latitude, Float, desc: "Address latitude", required: true
          param :longitude, Float, desc: "Address longitude", required: true
          param :name, String, desc: "Address person name"
          param :phone, String, desc: "Address person mobile phone number"
        end
      end
    end
  end

  api :GET, "orders", "all orders by status"
  desc "Path to render all orders in status, authorized for persons, couriers and operators"
  param :status, Order::STATUSES, desc: "Status to find orders, 'opened' by default"
  example self.multiple_example
  def index
    status = params[:status] || Order::OPENED
    @orders = if current_courier && status.to_sym == Order::OPENED
                Order.in_status(status.to_sym).open_for(current_courier.id)
              elsif current_operator
                Order.in_status(status.to_sym)
              else
                current_member.orders.in_status(status.to_sym)
              end

    paginate @orders, include: includes, per_page: 10
  end

  api :GET, "orders/:id", "single order"
  desc "Path to render single order, authorized for persons and couriers"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Order ID"
  example self.single_example
  def show
    @order = Order.find(params[:id])
    render json: @order, include: includes
  end

  api :POST, "orders", "create order"
  desc "Path to create order, authorized for persons"
  error 422, "Unprocessable entity"
  param_group :order
  example self.single_example
  def create
    @order = current_person.orders.new(order_params)

    if @order.save
      save_addresses
      render json: @order, status: :created, location: @order, include: includes
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, "orders/:id", "update order"
  desc "Path to update address, authorized for persons"
  error 404, "Record missing"
  error 422, "Unprocessable entity"
  param :id, Fixnum, desc: "Order ID", required: true
  param_group :order
  example self.single_example
  def update
    if @order.update(order_params)
      save_addresses
      handle_status_change if status_order_param
      render json: @order, status: :ok, include: includes
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order ||= Order.find(params[:id])
  end

  def order_params
    jsonapi_params.except(:status, :transport_id)
  end

  def permitted_params
    %i(name status description photo_confirm
       value price weight delivery_estimate
       grab_from grab_to deliver_from deliver_to
       transports)
  end

  def save_addresses
    %i(from_address addresses).each do |relation|
      AddressSaver.new(params, @order, relation).parse
    end
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

  def includes
    [:person, :deals, :assigned_deal, :addresses, :from_address, :transports]
  end
end
