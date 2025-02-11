class UsersController < ApplicationController
  before_action :authorize_request

  def update
    if @current_user.update(user_params)
      render json: { message: "Data updated successfully!", user: @current_user.as_json(except: [:password_digest]) }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:fullName, :image, :cityId, :stateId, :address, :zipcode)
    end
end
