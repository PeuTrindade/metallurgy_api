class InspectionsController < ApplicationController
  before_action :authorize_request
  before_action :set_inspection, only: [:show, :update, :destroy]

  def index
    inspections = current_user.inspections
    render json: inspections, status: :ok
  end

  def show
    render json: @inspection, status: :ok
  end

  def create
    @inspection = current_user.inspections.new(inspection_params)

    unless @inspection.save
      return render json: { message: "An error occurred while creating the inspection! Please try again.", errors: @inspection.errors }, status: :unprocessable_entity
    end

    render json: { message: "Inspection created successfully!", inspection: @inspection }, status: :ok
  end

  def update
    unless @inspection.update(inspection_params)
      return render json: { message: "An error occurred while updating the inspection!", errors: @inspection.errors }, status: :unprocessable_entity
    end

    render json: { message: "Inspection updated successfully!", inspection: @inspection }, status: :ok
  end

  def destroy
    if @inspection.destroy
      render json: { message: "Inspection deleted successfully!" }, status: :ok
    else
      render json: { message: "An error occurred while deleting the inspection!" }, status: :unprocessable_entity
    end
  end

  private
    def set_inspection
      @inspection = current_user.inspections.find_by(id: params[:id])
      
      return render json: { error: "Inspection not found or does not belong to the user" }, status: :not_found unless @inspection
    end

    def inspection_params
      params.require(:inspection).permit(:image, :description, :user_id, :flow_id, :part_id)
    end
end
