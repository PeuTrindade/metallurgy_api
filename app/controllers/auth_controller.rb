class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:register, :login, :validate_token]
  
  require 'jwt'

  SECRET_KEY = Rails.application.secrets.secret_key_base

  def register
    user = User.new(user_params)

    if user.save
      token = encode_token(user.id)
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def validate_token
    token = params[:token]
    return render json: { error: 'Token was not sent!' }, status: :unauthorized if token.blank?
  
    begin
      decoded_token = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
      payload = decoded_token.first
      user = User.find_by(id: payload['user_id'])
  
      if user
        render json: { user: user.as_json(except: [:password_digest]) }, status: :ok
      else
        render json: { error: 'User not found!' }, status: :unauthorized
      end
    rescue JWT::ExpiredSignature
      render json: { error: 'Token has expired!' }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: 'Invalid token!' }, status: :unauthorized
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user.id)

      render json: { user: user.as_json(except: [:password_digest]), token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def user_params
    params.permit(:email, :fullName, :cnpj, :password, :token)
  end

  def encode_token(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, SECRET_KEY, 'HS256')
  end
end
