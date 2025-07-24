##
# Controller responsável por gerenciar templates de formulários.
#
# Apenas usuários com ocupação "docente" podem acessar este controller.
# Templates que já estão vinculados a algum formulário não podem ser editados ou excluídos.
class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_docente!
  before_action :set_template, only: [:edit, :update, :destroy, :show]
  before_action :check_if_in_use, only: [:edit, :update, :destroy]

  ##
  # Lista todos os templates cadastrados no sistema.
  #
  # ==== Efeitos colaterais
  # - Carrega a variável de instância @templates com todos os templates ordenados por data de criação.
  def index
    @templates = Template.includes(:user).order(created_at: :desc)
  end

  ##
  # Exibe os detalhes de um template específico.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do template a ser exibido.
  #
  # ==== Efeitos colaterais
  # - Carrega o template na variável @template.
  def show
    @template = Template.find(params[:id])
  end

  ##
  # Inicializa um novo template para o formulário de criação.
  #
  # ==== Efeitos colaterais
  # - Instancia @template como um novo objeto vazio.
  def new
    @template = Template.new
  end

  ##
  # Cria um novo template e o associa ao usuário atual.
  #
  # ==== Parâmetros
  # * +params[:template]+ - Hash contendo:
  #   - +:nome+ - Nome do template.
  #   - +:formulario+ - Estrutura JSON com as perguntas e configurações do formulário.
  #
  # ==== Retorno
  # - Redireciona para o índice com mensagem de sucesso.
  # - Ou renderiza o formulário de criação com erros (status 422).
  #
  # ==== Efeitos colaterais
  # - Cria um novo registro na tabela `templates`.
  def create
    params[:template][:formulario] = JSON.parse(params[:template][:formulario]) if params[:template][:formulario].is_a?(String)

    @template = current_user.templates.build(template_params)
    if @template.save
      redirect_to templates_path, notice: "Template criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  ##
  # Carrega o template para edição.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do template a ser editado.
  #
  # ==== Efeitos colaterais
  # - Atribui o template à variável @template.
  def edit
    @template = Template.find(params[:id])
  end

  ##
  # Atualiza um template existente.
  #
  # ==== Parâmetros
  # * +params[:template]+ - Hash com dados atualizados do template.
  #
  # ==== Retorno
  # - Redireciona com mensagem de sucesso se for atualizado.
  # - Renderiza a view de edição em caso de erro.
  #
  # ==== Efeitos colaterais
  # - Atualiza o template no banco de dados.
  def update
    params[:template][:formulario] = JSON.parse(params[:template][:formulario]) if params[:template][:formulario].is_a?(String)

    if @template.update(template_params)
      redirect_to templates_path, notice: "Template atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  ##
  # Remove o template do banco de dados.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do template a ser removido.
  #
  # ==== Retorno
  # Redireciona para o índice com mensagem de sucesso.
  #
  # ==== Efeitos colaterais
  # - Exclui o template do banco (se não estiver em uso).
  def destroy
    @template.destroy
    redirect_to templates_path, notice: "Template excluído com sucesso!"
  end

  private

  ##
  # Garante que o usuário atual seja um docente.
  #
  # ==== Efeitos colaterais
  # - Redireciona para `root_path` caso o usuário não tenha permissão.
  def check_docente!
    redirect_to root_path unless current_user.ocupacao == "docente"
  end

  ##
  # Define o template atual com base no ID da URL.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do template.
  #
  # ==== Efeitos colaterais
  # - Atribui à variável @template.
  def set_template
    @template = Template.find(params[:id])
  end

  ##
  # Impede que templates vinculados a formulários sejam modificados.
  #
  # ==== Efeitos colaterais
  # - Redireciona com alerta se o template já estiver sendo usado.
  def check_if_in_use
    if @template.formularios.exists?
      redirect_to templates_path, alert: "Este template está sendo utilizado em um formulário e não pode ser alterado ou excluído."
    end
  end

  ##
  # Permite apenas os parâmetros autorizados para criação/edição de templates.
  #
  # ==== Retorno
  # * Hash com os campos permitidos: `:nome` e `formulario` (JSON).
  def template_params
    params.require(:template).permit(:nome, formulario: {})
  end
end
