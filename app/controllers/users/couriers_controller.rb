class CouriersController < UsersController
  devise_token_auth_group :member, contains: [:person, :courier]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_courier!, only: [:me, :update]

  def index
    @couriers = Courier.all
    render json: @couriers, include: "**"
  end

  private

  def set_resource
    @resourse ||= Courier.find(params[:id])
  end

  def set_current_resource
    @resourse ||= current_courier
  end

  def resourse_params
    params.require(:courier).permit(:name)
  end
end
