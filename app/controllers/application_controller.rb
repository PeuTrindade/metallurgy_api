class ApplicationController < ActionController::API
  before_action :authorize_request

  SECRET_KEY = Rails.application.secrets.secret_key_base

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
      @current_user = User.find(decoded[0]['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: ['Access denied! The token sent is invalid.'] }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find(decoded_token[:user_id]) if decoded_token
  end

  def decoded_token
    header = request.headers['Authorization']

    if header
      token = header.split(' ').last
      begin
        JWT.decode(token, Rails.application.secrets.secret_key_base).first
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
