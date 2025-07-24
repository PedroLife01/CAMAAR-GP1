##
# Controller base da aplicação CAMAAR.
#
# Define comportamentos e configurações comuns a todos os controllers,
# como permissões de parâmetros adicionais do Devise e redirecionamentos
# pós-login e logout, com base na ocupação do usuário (docente, dicente ou admin).
class ApplicationController < ActionController::Base
  # Permite navegação apenas por navegadores modernos
  allow_browser versions: :modern

  # Antes de qualquer ação, se estiver usando Devise, permite parâmetros extras
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  ##
  # Define o caminho de redirecionamento após o login do usuário.
  #
  # Este método é usado pelo Devise para decidir para onde enviar o usuário
  # após login, baseado em sua ocupação.
  #
  # ==== Parâmetros
  # * +resource+ - Objeto do usuário autenticado (instância de +User+)
  #
  # ==== Retorno
  # * Uma +String+ com o path para onde o usuário será redirecionado.
  #
  # ==== Regras de redirecionamento:
  # * Docente: vai para a página de importação SIGAA
  # * Dicente: vai para a página inicial
  # * Admin: vai para o painel do Rails Admin
  #
  # ==== Efeitos colaterais
  # Redireciona o fluxo da aplicação após login
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
  # Define o caminho de redirecionamento após o logout do usuário.
  #
  # ==== Parâmetros
  # * +resource_or_scope+ - Escopo utilizado pelo Devise (pode ser o símbolo do modelo ou o recurso em si)
  #
  # ==== Retorno
  # * Uma +String+ representando o caminho para a página inicial.
  #
  # ==== Efeitos colaterais
  # Redireciona o usuário após logout
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  ##
  # Permite a inclusão de parâmetros adicionais nos formulários de cadastro
  # e edição de conta do Devise.
  #
  # Parâmetros adicionados:
  # * +:nome+
  # * +:ocupacao+ (docente, dicente ou admin)
  # * +:usuario+ (login do SIGAA)
  # * +:curso+
  # * +:formacao+
  # * +:matricula+
  #
  # ==== Parâmetros
  # * Nenhum argumento direto, mas opera sobre +devise_parameter_sanitizer+
  #
  # ==== Efeitos colaterais
  # Permite ao Devise aceitar mais campos no sign up e account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
  end
end
