class ApplicationController < ActionController::Base
  before_action :configure_permited_parameters, if: :devise_controller?

  def home
    redirect_to new_user_session_path unless user_signed_in?
  end

  private

    def configure_permited_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end

end
