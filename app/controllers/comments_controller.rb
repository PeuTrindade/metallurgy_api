class CommentsController < ApplicationController
  before_action :authorize_request
  before_action :set_comment, only: [:show, :update, :destroy]

  def index
    comments = current_user.comments
    render json: comments, status: :ok
  end

  def show
    render json: @comment, status: :ok
  end

  def create
    @comment = current_user.comments.new(comment_params)

    unless @comment.save
      return render json: { message: "An error occurred while creating the comment! Please try again.", errors: @comment.errors }, status: :unprocessable_entity
    end

    render json: { message: "Comment created successfully!", comment: @comment }, status: :ok
  end

  def update
    unless @comment.update(comment_params)
      return render json: { message: "An error occurred while updating the comment!", errors: @comment.errors }, status: :unprocessable_entity
    end

    render json: { message: "Comment updated successfully!", comment: @comment }, status: :ok
  end

  def destroy
    if @comment.destroy
      render json: { message: "Comment deleted successfully!" }, status: :ok
    else
      render json: { message: "An error occurred while deleting the comment!" }, status: :unprocessable_entity
    end
  end

  private
    def set_comment
      @comment = current_user.comments.find_by(id: params[:id])
      
      return render json: { error: "Comment not found or does not belong to the user" }, status: :not_found unless @comment
    end

    def comment_params
      params.require(:comment).permit(:description, :user_id, :flow_id, :part_id)
    end
end
