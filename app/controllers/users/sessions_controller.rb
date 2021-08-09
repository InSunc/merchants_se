# frozen_string_literal: true
require 'jwt_service'

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  protect_from_forgery with: :null_session

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    logger.debug request.content_type
    if request.content_type != 'application/json'
      logger.info "SignIn method: form"
      super
    else
      logger.info "SignIn method: json"
      token = warden.authenticate!(:token_gen_strategy)
      render json: {"token" => token.to_s}
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
