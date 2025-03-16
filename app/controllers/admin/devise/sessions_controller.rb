# frozen_string_literal: true

class Admin::Devise::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params
  layout 'devise'

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    params[:admin][:subdomain] = request.subdomain
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end
end
