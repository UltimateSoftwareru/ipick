class ComplainsController < ApplicationController
  devise_token_auth_group :member, contains: [:person, :courier, :operator]
  devise_token_auth_group :complainer, contains: [:person, :courier]
  before_action :authenticate_complainer!, only: [:create, :destroy]
  before_action :authenticate_member!, only: [:show]
  before_action :authenticate_operator!, only: [:index, :update]
  before_action :load_complain, only: [:show, :update, :destroy]

  # GET /complains
  # GET /complains.json
  def index
    @complains = Complain.in_status(params[:status] || Complain::OPENED)

    render json: @complains
  end

  # GET /complains/1
  # GET /complains/1.json
  def show
    render json: @complain
  end

  # POST /complains
  # POST /complains.json
  def create
    @complain = current_complainer.complains.new(complain_params)

    if @complain.save
      render json: @complain, status: :created, location: @complain
    else
      render json: @complain.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /complains/1
  # PATCH/PUT /complains/1.json
  def update
    if @complain.update(complain_update_params)
      handle_status_change if status_complain_param
      render json: @complain, status: :ok, location: @complain
    else
      render json: @complain.errors, status: :unprocessable_entity
    end
  end

  # DELETE /complains/1
  # DELETE /complains/1.json
  def destroy
    @complain.destroy

    head :no_content
  end

  private

  def load_complain
    @complain ||= Complain.find(params[:id])
  end

  def complain_params
    params = jsonapi_params
    %i(from_type to_type).each do |type|
      next unless params[type]
      params[type] = params[type].singularize.capitalize
    end
    params.except(:status)
  end

  def complain_update_params
    complain_params.merge(user_id: current_operator.id)
  end

  def permitted_polymorphic
    %i(from to)
  end

  def permitted_params
    %i(subject resolution status deal) + permitted_polymorphic
  end

  def status_complain_param
    jsonapi_params[:status]
  end

  def handle_status_change
    case status_complain_param.to_sym
    when Complain::RESOLVED
      @complain.resolve!
    end
  end
end
