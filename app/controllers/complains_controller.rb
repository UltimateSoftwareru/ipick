class ComplainsController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  devise_token_auth_group :complainer, contains: [:person, :courier]
  before_action :authenticate_complainer!, only: [:create]
  before_action :authenticate_member!, only: [:show]
  before_action :authenticate_operator!, only: [:index, :update]
  before_action :load_complain, only: [:show, :update]

  resource_description do
    desc "Complain represents a records of issues of persons to couriers or couriers to person"
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  def_param_group :complain do
    param :data, Hash, desc: "Complain Data", required: true do
      param :attributes, Hash, desc: "Complain Attributes", action_aware: true, required: true do
        param :subject, Integer, desc: "Complain subject"
        param :body, String, desc: "Complain body"
        param :resolution, String, desc: "Complain resolution"
        param :status, Complain::STATUSES, desc: "Complain status"
      end
      param :relationships, Hash, desc: "Complain Relationships, polymorphic associated", required: true do
        param :from, Hash, desc: "From Relationship", required: true do
          param :type, String, desc: "Person type"
          param :id, Fixnum, desc: "Person id"
        end
        param :to, Hash, desc: "To Relationship, polymorphic associated", required: true do
          param :type, String, desc: "Person type"
          param :id, Fixnum, desc: "Person id"
        end
        param :order, Hash, desc: "Order Relationship, order connected to the complain, if exists" do
          param :type, String, desc: "Order type"
          param :id, Fixnum, desc: "Order id"
        end
      end
    end
  end

  api :GET, "complains", "all complains"
  desc "Path to render all complains in status, authorized for operator only"
  param :status, Complain::STATUSES, desc: "Status to find complains, 'opened' by default"
  param :page, Integer, "Used to Pagination, per_page: 10"
  example self.multiple_example
  def index
    @complains = Complain.in_status(params[:status] || Complain::OPENED)

    paginate @complains, include: includes, per_page: 10
  end

  api :GET, "complains/:id", "single complain"
  desc "Path to render single complain, authorized for person, courier and operator"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Complain ID"
  example self.single_example
  def show
    render json: @complain, include: includes
  end

  api :POST, "complains", "create complain"
  desc "Path to create complain, authorized for persons and couriers"
  error 422, "Unprocessable entity"
  param_group :complain
  example self.single_example
  def create
    @complain = current_complainer.complains.new(complain_params)

    if @complain.save
      render json: @complain, status: :created, include: includes
    else
      render json: @complain.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, "complains/:id", "update complain"
  desc "Path to update address, authorized for persons and couriers"
  error 404, "Record missing"
  error 422, "Unprocessable entity"
  param :id, Fixnum, desc: "Complain ID", required: true
  param_group :complain
  example self.single_example
  def update
    if @complain.update(complain_update_params)
      handle_status_change if status_complain_param
      render json: @complain, status: :ok, include: includes
    else
      render json: @complain.errors, status: :unprocessable_entity
    end
  end

  private

  def load_complain
    @complain ||= Complain.find_by(id: params[:id])
  end

  def complain_params
    params = jsonapi_params
    %i(from_type to_type).each do |type|
      next unless params[type]
      params[type] = params[type].singularize.capitalize
    end
    params.except(:status)
  end

  def complain_update_params
    complain_params.merge(user_id: current_operator.id)
  end

  def permitted_polymorphic
    %i(from to)
  end

  def permitted_params
    %i(subject resolution status order) + permitted_polymorphic
  end

  def status_complain_param
    jsonapi_params[:status]
  end

  def includes
    %i(operator order from to)
  end

  def handle_status_change
    case status_complain_param.to_sym
    when Complain::RESOLVED
      @complain.resolve!
    end
  end
end
