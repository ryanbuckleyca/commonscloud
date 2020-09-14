class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :address, :phone, :img_url, :password)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :address, :phone, :img_url, :password, :current_password)}
  end
end
