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
def show
    @user = User.find(params[:id])
  end
  