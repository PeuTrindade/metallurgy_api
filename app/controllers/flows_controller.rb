class FlowsController < ApplicationController
  before_action :authorize_request
  before_action :set_flow, only: [:update, :destroy]

  def index
    flows = current_user.flows
    render json: { flows: flows }, status: :ok
  end

  def create
    @flow = current_user.flows.new(flow_params)

    if @flow.save
      render json: { message: "Flow registered successfully!", flow: @flow }, status: :ok
    else
      render json: { message: "An error occurred while registering flow! Please try again.", errors: @flow.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @flow.user_id == current_user.id
      if @flow.update(flow_params)
        render json: { message: "Flow updated successfully!", flow: @flow }, status: :ok
      else
        render json: { message: "An error occurred while updating flow! Please try again.", errors: @flow.errors}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @flow.user_id == current_user.id
      if @flow.destroy()
        render json: { message: "Flow deleted successfully!", flow: @flow }, status: :ok
      else
        render json: { message: "An error occurred while deleting flow! Please try again."}, status: :unprocessable_entity
      end
    end
  end

  private
    def set_flow
      @flow = Flow.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Flow not found' }, status: :not_found
    end

    def flow_params
      params.require(:flow).permit(:name, :description)
    end
end
