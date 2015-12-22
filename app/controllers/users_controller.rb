class UsersController < ApplicationController
  before_action :set_current_resource, only: [:me, :update]
  before_action :set_resource, only: :show

  # GET /{{resourses}}/me
  # GET /{{resourses}}/me.json
  def me
    render json: @resourse
  end

  # GET /{{resourses}}/1
  # GET /{{resourses}}/1.json
  def show
    render json: @resourse
  end

  # PATCH/PUT /{{resourses}}
  # PATCH/PUT /{{resourses}}.json
  def update
    if @resourse.update(resourse_params)
      head :no_content
    else
      render json: @resourse.errors, status: :unprocessable_entity
    end
  end
end
