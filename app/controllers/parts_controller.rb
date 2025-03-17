class PartsController < ApplicationController
  before_action :authorize_request
  before_action :set_part, only: [:update, :destroy]

  def index
    parts = current_user.parts
    render json: { parts: parts }, status: :ok
  end

  def show
    part = current_user.parts.includes(:steps, :inspection).find_by(id: params[:id])

    if part
      render json: {
        part: part.as_json(include: [:steps, :inspection])
      }, status: :ok
    else
      render json: { error: "Part not found or does not belong to the user" }, status: :not_found
    end
  end

  def create
    @part = current_user.parts.new(part_params)
  
    unless @part.save
      return render json: { message: "An error occurred while registering part! Please try again.", errors: @part.errors }, status: :unprocessable_entity
    end
  
    begin
      ActiveRecord::Base.transaction do
        Inspection.create!(
          description: "...",
          image: nil,
          user_id: current_user.id,
          flow_id: @part.flow_id,
          part_id: @part.id
        )

        flow_id = @part.flow_id
        steps_flows = StepsFlow.where(flow_id: flow_id)
  
        steps_flows.each do |step_flow|
          step = Step.new(
            part_id: @part.id,
            name: step_flow.name,
            flow_id: flow_id,
            user_id: current_user.id
          )
  
          unless step.save
            raise ActiveRecord::Rollback, "Error creating steps"
          end
        end
      end
    rescue StandardError => e
      return render json: { message: "An error occurred while creating steps!", errors: e.message }, status: :unprocessable_entity
    end
  
    render json: { message: "Part registered successfully with steps!", part: @part }, status: :ok
  end
  

  def by_flow
    parts = Part.where(flow_id: params[:flow_id])

    if parts.any?
      render json: {parts: parts}, status: :ok
    else
      render json: { message: "No parts found for this flow_id" }, status: :not_found
    end
  end
  

  def update
    if @part.user_id == current_user.id
      if @part.update(part_params)
        render json: { message: "Part updated successfully!", part: @part }, status: :ok
      else
        render json: { message: "An error occurred while updating part! Please try again.", errors: @part.errors}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @part.user_id == current_user.id
      if @part.destroy()
        render json: { message: "Part deleted successfully!", part: @part }, status: :ok
      else
        render json: { message: "An error occurred while deleting part! Please try again."}, status: :unprocessable_entity
      end
    end
  end

  private
    def set_part
      @part = Part.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Part not found' }, status: :not_found
    end

    def part_params
      params.require(:part).permit(:name, :tag, :hiringCompany, :image, :flow_id, :description)
    end
end
