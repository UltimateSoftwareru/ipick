class CouriersController < ResourcesController
  before_action :authenticate_courier!

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
