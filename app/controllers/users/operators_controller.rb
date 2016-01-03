class OperatorsController < UsersController
  before_action :authenticate_operator!

  def index
    @operators = Operator.all
    render json: @operators, include: "**"
  end

  private

  def set_resource
    @resourse ||= Operator.find(params[:id])
  end

  def set_current_resource
    @resourse ||= current_operator
  end

  def resourse_params
    params.require(:operator).permit(:name)
  end
end
