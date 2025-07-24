##
# Exibe o perfil de um usuário.
#
# ==== Parâmetros
# * +params[:id]+ - ID do usuário a ser exibido.
#
# ==== Retorno
# Renderiza a view correspondente com os dados do usuário.
#
# ==== Efeitos colaterais
# Carrega a variável de instância +@user+ com o usuário encontrado.
class UsersController < ApplicationController

  ##
  # Ação responsável por exibir o perfil de um usuário específico.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do usuário a ser exibido.
  #
  # ==== Efeitos colaterais
  # - Atribui à variável de instância +@user+ o usuário encontrado.
  def show
    @user = User.find(params[:id])
  end
end
