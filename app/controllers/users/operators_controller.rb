class OperatorsController < UsersController
  before_action :authenticate_operator!

  resource_description do
    desc "Operators personal info routes"
    formats ["json"]
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  def_param_group :courier do
    param :data, Hash, desc: "Operator Data", required: true do
      param :attributes, Hash, desc: "Operator Attributes", required: true do
        param :email, String, desc: "Operator email"
        param :picture, String, desc: "Operator picture"
        param :phone, String, desc: "Operator phone"
      end
    end
  end

  api :GET, "operators", "all operators"
  desc "Path to render all operators, authorized for persons, operators and operators"
  example self.multiple_example
  def index
    @operators = Operator.all
    render json: @operators, include: "**"
  end

  api :GET, "operators/me", "current operators personal info"
  desc "Path to render current logged in operator personal info, authorized for operators only"
  example self.single_example
  def me
    render json: @resourse, include: includes
  end

  api :GET, "operators/:id", "show operator personal info"
  desc "Path to render operator personal info, authorized for operators only"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Operator ID"
  example self.single_example
  def show
    render json: @resourse, include: includes
  end

  api :PATCH, "operators/:id", "update operator"
  desc "Path to update current logged in operators personal info, authorized for operators only"
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
    @resourse ||= Operator.find(params[:id])
  end

  def set_current_resource
    @resourse ||= current_operator
  end

  def permitted_params
    %i(email picture name nickname phone)
  end
end
