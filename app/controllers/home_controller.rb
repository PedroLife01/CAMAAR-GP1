##
# Controller responsável por exibir a página inicial do sistema.
#
# A página pode ser personalizada conforme o perfil do usuário logado (caso haja lógica na view).
class HomeController < ApplicationController

  ##
  # Exibe a página inicial da aplicação.
  #
  # ==== Efeitos colaterais
  # Pode renderizar conteúdo diferente dependendo do usuário logado (definido na view).
  def index
  end
end
