##
# Exibe o perfil de um usuário.
#
# ==== Parâmetros
# * +params[:id]+ - ID do usuário a ser exibido.
#
# ==== Efeitos colaterais
# Carrega @user para uso na view.
def show
    @user = User.find(params[:id])
  end
  