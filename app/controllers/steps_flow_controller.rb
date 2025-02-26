class StepsFlowController < ApplicationController
  before_action :authorize_request
  before_action :set_steps_flow, only: [:update, :destroy]

  def index
    steps_flows = current_user.steps_flows
    render json: { steps_flows: steps_flows }, status: :ok
  end

  def show
    steps_flow = current_user.steps_flows.find_by(id: params[:id])

    if steps_flow
      render json: steps_flow, status: :ok
    else
      render json: { error: "Step not found or does not belong to the user" }, status: :not_found
    end
  end

  def create
    @steps_flow = current_user.steps_flows.new(steps_flow_params)

    if @steps_flow.save
      render json: { message: "Step registered successfully!", steps_flow: @steps_flow }, status: :ok
    else
      render json: { message: "An error occurred while registering step! Please try again.", errors: @steps_flow.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @steps_flow.user_id == current_user.id
      if @steps_flow.update(steps_flow_params)
        render json: { message: "Step updated successfully!", steps_flow: @steps_flow }, status: :ok
      else
        render json: { message: "An error occurred while updating step! Please try again.", errors: @steps_flow.errors}, status: :unprocessable_entity
      end
    end
  end

  def by_flow
    steps_flows = StepsFlow.where(flow_id: params[:flow_id])

    if steps_flows.any?
      render json: { steps_flows: steps_flows }, status: :ok
    else
      render json: { message: "No steps found for this flow_id" }, status: :not_found
    end
  end

  def destroy
    if @steps_flow.user_id == current_user.id
      if @steps_flow.destroy()
        render json: { message: "Step deleted successfully!", steps_flow: @steps_flow }, status: :ok
      else
        render json: { message: "An error occurred while deleting step! Please try again."}, status: :unprocessable_entity
      end
    end
  end

  private
    def set_steps_flow
      @steps_flow = StepsFlow.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'StepsFlow not found' }, status: :not_found
    end

    def steps_flow_params
      params.require(:steps_flow).permit(:name, :user_id, :flow_id)
    end
end
