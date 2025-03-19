class SuggestionsController < ApplicationController
  before_action :authorize_request
  before_action :set_suggestion, only: [:show, :update, :destroy]

  def index
    suggestions = current_user.suggestions
    render json: suggestions, status: :ok
  end

  def show
    render json: @suggestion, status: :ok
  end

  def create
    @suggestion = current_user.suggestions.new(suggestion_params)

    unless @suggestion.save
      return render json: { message: "An error occurred while creating the suggestion! Please try again.", errors: @suggestion.errors }, status: :unprocessable_entity
    end

    render json: { message: "Suggestion created successfully!", suggestion: @suggestion }, status: :ok
  end

  def update
    unless @suggestion.update(suggestion_params)
      return render json: { message: "An error occurred while updating the suggestion!", errors: @suggestion.errors }, status: :unprocessable_entity
    end

    render json: { message: "Suggestion updated successfully!", suggestion: @suggestion }, status: :ok
  end

  def destroy
    if @suggestion.destroy
      render json: { message: "Suggestion deleted successfully!" }, status: :ok
    else
      render json: { message: "An error occurred while deleting the suggestion!" }, status: :unprocessable_entity
    end
  end

  private
    def set_suggestion
      @suggestion = current_user.suggestions.find_by(id: params[:id])
      
      return render json: { error: "Suggestion not found or does not belong to the user" }, status: :not_found unless @suggestion
    end

    def suggestion_params
      params.require(:suggestion).permit(:description, :user_id, :flow_id, :part_id)
    end
end
