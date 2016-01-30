class PeopleController < UsersController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_person!, only: [:me, :update]

  resource_description do
    desc "Persons personal info routes"
    formats ["json"]
    param "Access-Token: ", String, desc: "Access-Token header is expected on all calls", required: true
    param "Client: ", String, desc: "Client header is expected on all calls", required: true
    param "Uid: ", String, desc: "Uid header is expected on all calls", required: true
    error 401, "Unauthorized - Returned when authentication can't be achieved via login or missing/expired api token"
    error 501, "Not Implemented - Returned when the API version isn't provided in the request headers or isn't supported."
  end

  def_param_group :person do
    param :data, Hash, desc: "Person Data", required: true do
      param :attributes, Hash, desc: "Person Attributes", required: true do
        param :email, String, desc: "Person email"
        param :picture, String, desc: "Person picture"
        param :phone, String, desc: "Person phone"
      end
    end
  end

  api :GET, "people", "all people"
  desc "Path to render all people, authorized for persons, people and operators"
  example self.multiple_example
  def index
    @persons = Person.all.includes(includes)

    render json: @persons, include: includes
  end

  api :GET, "people/me", "current people personal info"
  desc "Path to render current logged in person personal info, authorized for people only"
  example self.single_example
  def me
    render json: @resourse, include: includes
  end

  api :GET, "people/:id", "show person personal info"
  desc "Path to render person personal info, authorized for people, couriers and operators"
  error 404, "Record missing"
  param :id, Fixnum, required: true, desc: "Operator ID"
  example self.single_example
  def show
    render json: @resourse, include: includes
  end

  api :PATCH, "people/:id", "update person"
  desc "Path to update current logged in people personal info, authorized for people only"
  error 404, "Record missing"
  error 422, "Unprocessable entity"
  param_group :person
  example self.single_example
  def update
    if @resourse.update(jsonapi_params)
      render json: @resourse, include: includes
    else
      render json: @resourse.errors, status: :unprocessable_entity
    end
  end

  private

  def set_resource
    @resourse ||= Person.find_by(id: params[:id])
  end

  def set_current_resource
    @resourse ||= current_person
  end

  def permitted_params
    %i(email picture name nickname phone)
  end

  def includes
    %i(addresses)
  end
end
