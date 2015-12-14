class CouriersController < ResourcesController
  devise_token_auth_group :member, contains: [:user, :courier]
  before_action :authenticate_member!, only: [:index, :show]
  before_action :authenticate_courier!, only: [:me, :update]

  def index
    @couriers = Courier.all
    render json: @couriers
  end

  private

  def set_resource
    @resourse ||= Courier.find(params[:id])
  end

  def set_current_resource
    @resourse ||= current_courier
  end

  def resourse_params
    params.require(:data)
          .require(:attributes)
          .permit(:name)
  end
end
