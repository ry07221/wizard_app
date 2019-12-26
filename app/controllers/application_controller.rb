class ApplicationController < ActionController::Base

  # name&ageカラムを追加したため編集
  before_action :configure_permitted_parameters, if: :devise_controller?


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :age])
  end

end
