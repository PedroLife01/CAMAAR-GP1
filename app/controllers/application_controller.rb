class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Redirecionamento pós-login
  def after_sign_in_path_for(resource)
    case resource.ocupacao
    when "docente"
      sigaa_importar_path
    when "dicente"
      root_path
    when "admin"
      rails_admin_path
    else
      root_path
    end
  end

  # Redirecionamento pós-logout
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # Permitir atributos extras para o Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
  end
end
