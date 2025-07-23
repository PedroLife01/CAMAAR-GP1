##
# Controller responsável por gerenciar templates de formulários.
#
# Apenas usuários com ocupação "docente" podem acessar este controller.
# Templates em uso não podem ser editados ou excluídos.
class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_docente!
  before_action :set_template, only: [:edit, :update, :destroy, :show]
  before_action :check_if_in_use, only: [:edit, :update, :destroy]

  ##
  # Lista todos os templates cadastrados, em ordem decrescente de criação.
  #
  # ==== Efeitos colaterais
  # Carrega @templates para a view.
  def index
    @templates = Template.includes(:user).order(created_at: :desc)
  end

  ##
  # Exibe um template específico.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do template
  #
  # ==== Efeitos colaterais
  # Carrega @template para a view.
  def show
    @template = Template.find(params[:id])
  end

  ##
  # Inicializa um novo template para o formulário de criação.
  #
  # ==== Efeitos colaterais
  # Cria uma instância vazia de Template.
  def new
    @template = Template.new
  end

  ##
  # Cria um novo template associado ao usuário atual.
  #
  # ==== Parâmetros
  # * +params[:template]+ - hash com nome e estrutura do formulário (em JSON).
  #
  # ==== Efeitos colaterais
  # Salva no banco ou renderiza erro de validação.
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
  # * +params[:id]+ - ID do template
  #
  # ==== Efeitos colaterais
  # Carrega @template.
  def edit
    @template = Template.find(params[:id])
  end

  ##
  # Atualiza um template existente.
  #
  # ==== Parâmetros
  # * +params[:template]+ - hash atualizado com nome e estrutura em JSON.
  #
  # ==== Efeitos colaterais
  # Atualiza o registro ou renderiza erro.
  def update
    params[:template][:formulario] = JSON.parse(params[:template][:formulario]) if params[:template][:formulario].is_a?(String)

    if @template.update(template_params)
      redirect_to templates_path, notice: "Template atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  ##
  # Exclui um template do banco de dados.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do template
  #
  # ==== Efeitos colaterais
  # Remove o template do banco.
  def destroy
    @template.destroy
    redirect_to templates_path, notice: "Template excluído com sucesso!"
  end

  private

  ##
  # Verifica se o usuário atual é docente.
  #
  # ==== Efeitos colaterais
  # Redireciona para root_path caso não seja docente.
  def check_docente!
    redirect_to root_path unless current_user.ocupacao == "docente"
  end

  ##
  # Carrega o template com base no ID informado.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do template
  def set_template
    @template = Template.find(params[:id])
  end

  ##
  # Impede edição ou exclusão de templates que estão em uso.
  #
  # ==== Efeitos colaterais
  # Redireciona com alerta caso o template esteja vinculado a formulários.
  def check_if_in_use
    if @template.formularios.exists?
      redirect_to templates_path, alert: "Este template está sendo utilizado em um formulário e não pode ser alterado ou excluído."
    end
  end

  ##
  # Filtra e permite apenas os parâmetros válidos para template.
  #
  # ==== Retorno
  # Hash com os campos `:nome` e `formulario` (estrutura do formulário).
  def template_params
    params.require(:template).permit(:nome, formulario: {})
  end
end
