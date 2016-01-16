class PeopleController < UsersController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_person!, only: [:me, :update]

  def index
    @persons = Person.all

    render json: @persons, include: "**"
  end

  private

  def set_resource
    @resourse ||= Person.find(params[:id])
  end

  def set_current_resource
    @resourse ||= current_person
  end

  def permitted_params
    %i(email picture name nickname phone)
  end
end
