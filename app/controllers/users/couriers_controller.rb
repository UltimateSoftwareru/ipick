class CouriersController < UsersController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
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

  def permitted_params
    %i(email picture name nickname phone status transport latitude longitude)
  end
end
