# frozen_string_literal: true

class Users::Devise::SessionsController < Devise::SessionsController
  layout 'application'
  
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    flash.now[:do_not_fade] = true
    super
    flash.now[:notice] = 'Logged in successfully.'
    flash[:notice] = 'Logged in successfully.'
  end

  # DELETE /resource/sign_out
  def destroy
    super
    flash.now[:notice] = 'Logged out successfully.'
    flash[:notice] = 'Logged out successfully.'
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password])
  end
end
