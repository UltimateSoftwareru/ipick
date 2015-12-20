class PeopleController < UsersController
  before_action :authenticate_person!

  def index
    @persons = Person.all
    render json: @persons
  end

  private

  def set_resource
    @resourse ||= Person.find(params[:id])
  end

  def set_current_resource
    @resourse ||= current_person
  end

  def resourse_params
    params.require(:person).permit(:name)
  end
end
