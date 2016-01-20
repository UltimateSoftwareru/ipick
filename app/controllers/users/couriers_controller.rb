class CouriersController < UsersController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_courier!, only: [:me, :update]

  resource_description do
    desc "Couriers personal info routes"
    formats ["json"]
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  def_param_group :courier do
    param :data, Hash, desc: "Courier Data", required: true do
      param :attributes, Hash, desc: "Courier Attributes", required: true do
        param :email, String, desc: "Courier email"
        param :picture, String, desc: "Courier picture"
        param :phone, String, desc: "Courier phone"
        param :status, String, desc: "Courier status"
        param :latitude, String, desc: "Courier current latitude"
        param :longitude, String, desc: "Courier current longitude"
      end
      param :relationships, Hash, desc: "Couriers relationships", required: true do
        param :transport, Hash, desc: "Courier transport relationship" do
          param :type, String, desc: "Transport type"
          param :id, Fixnum, desc: "Transport id"
        end
      end
    end
  end

  api :GET, "couriers", "all couriers"
  desc "Path to render all couriers, authorized for persons, couriers and operators"
  example self.multiple_example
  def index
    @couriers = Courier.all
    render json: @couriers, include: "**"
  end

  api :GET, "couriers/me", "current couriers personal info"
  desc "Path to render current logged in courier personal info, authorized for couriers only"
  example self.single_example
  def me
    render json: @resourse, include: includes
  end

  api :GET, "couriers/:id", "show courier personal info"
  desc "Path to render courier personal info, authorized for couriers only"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Operator ID"
  example self.single_example
  def show
    render json: @resourse, include: includes
  end

  api :PATCH, "couriers/:id", "update courier"
  desc "Path to update current logged in couriers personal info, authorized for couriers only"
  error 404, "Record missing"
  error 422, "Unprocessable entity"
  param_group :courier
  example self.single_example
  def update
    if @resourse.update(jsonapi_params)
      head :no_content
    else
      render json: @resourse.errors, status: :unprocessable_entity
    end
  end

  private

  def set_resource
    @resourse ||= Courier.find(params[:id])
  end

  def set_current_resource
    @resourse ||= current_courier
  end

  def permitted_params
    %i(email picture name nickname phone status transport latitude longitude)
  end
end
