##
# Controller responsável por exibir a página inicial do sistema.
#
# A lógica da view pode ser adaptada para mostrar conteúdos específicos
# com base no tipo de usuário logado (admin, docente ou discente).
#
# Este controller é acessado por padrão em `root_path`.
class HomeController < ApplicationController

  ##
  # Renderiza a página inicial da aplicação.
  #
  # ==== Efeitos colaterais
  # Nenhuma alteração no banco de dados.
  # A view associada pode alterar o conteúdo renderizado com base em +current_user+.
  #
  # ==== Parâmetros
  # Nenhum.
  #
  # ==== Retorno
  # Renderiza a view +home/index.html.erb+.
  def index
  end
end
