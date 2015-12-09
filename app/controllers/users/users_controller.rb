class UsersController < ResourcesController
  before_action :authenticate_user!

  def index
    @users = User.all
    render json: @users
  end

  private

  def set_resource
    @resourse ||= User.find(params[:id])
  end

  def set_current_resource
    @resourse ||= current_user
  end

  def resourse_params
    params.require(:data)
          .require(:attributes)
          .permit(:name)
  end
end
