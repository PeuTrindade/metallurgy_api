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
      render json: { errors: ['Acesso negado. Token inválido.'] }, status: :unauthorized
    end
  end
end
