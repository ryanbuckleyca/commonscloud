class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :address, :img_url, :phone, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :address, :img_url, :phone, :password, :current_password) }
  end
end
