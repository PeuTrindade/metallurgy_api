class StepsController < ApplicationController
  before_action :authorize_request
  before_action :set_step, only: [:update, :destroy]

  def index
    steps = current_user.steps
    render json: { steps: steps }, status: :ok
  end

  def show
    step = current_user.steps.find_by(id: params[:id])

    if step
      render json: step, status: :ok
    else
      render json: { error: "Step not found or does not belong to the user" }, status: :not_found
    end
  end

  def create
    @step = current_user.steps.new(step_params)

    if @step.save
      render json: { message: "Step registered successfully!", step: @step }, status: :ok
    else
      render json: { message: "An error occurred while registering step! Please try again.", errors: @step.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @step.user_id == current_user.id
      if @step.update(step_params)
        render json: { message: "Step updated successfully!", step: @step }, status: :ok
      else
        render json: { message: "An error occurred while updating step! Please try again.", errors: @step.errors}, status: :unprocessable_entity
      end
    end
  end

  def by_flow
    steps = Step.where(flow_id: params[:flow_id])

    if steps.any?
      render json: {steps: steps}, status: :ok
    else
      render json: { message: "No steps found for this flow_id" }, status: :not_found
    end
  end

  def destroy
    if @step.user_id == current_user.id
      if @step.destroy()
        render json: { message: "Step deleted successfully!", step: @step }, status: :ok
      else
        render json: { message: "An error occurred while deleting step! Please try again."}, status: :unprocessable_entity
      end
    end
  end

  private
    def set_step
      @step = Step.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Step not found' }, status: :not_found
    end

    def step_params
      params.require(:step).permit(:name, :startDate, :finishDate, :image, :description, :flow_id)
    end
end
