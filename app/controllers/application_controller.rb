##
# Controller base da aplicação.
#
# Define comportamentos comuns para todos os controllers, incluindo permissões do Devise
# e redirecionamentos após login/logout.
class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  ##
  # Define o caminho para redirecionamento após login, com base na ocupação do usuário.
  #
  # ==== Parâmetros
  # * +resource+ - Objeto do usuário autenticado (usuário Devise)
  #
  # ==== Retorno
  # Caminho de redirecionamento (String)
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

  ##
  # Define o caminho para redirecionamento após logout.
  #
  # ==== Parâmetros
  # * +resource_or_scope+ - escopo Devise (pode ser o símbolo ou o próprio recurso)
  #
  # ==== Retorno
  # Caminho para a página inicial (String)
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  ##
  # Permite atributos adicionais no Devise para cadastro e atualização de conta.
  #
  # ==== Efeitos colaterais
  # Altera os parâmetros aceitos por Devise.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
  end
end
