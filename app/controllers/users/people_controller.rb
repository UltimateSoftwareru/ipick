class PeopleController < UsersController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_person!, only: [:me, :update]

  api :GET, 'people'
  def index
    @persons = Person.all.includes(includes)

    render json: @persons, include: includes
  end

  private

  def set_resource
    @resourse ||= Person.find_by(id: params[:id]).includes(includes)
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
