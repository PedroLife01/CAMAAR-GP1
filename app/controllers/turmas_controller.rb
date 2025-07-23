##
# Controller responsável por gerenciar as ações relacionadas às turmas.
#
# Possui métodos para CRUD completo, busca de alunos e visualização de formulários e respostas.
class TurmasController < ApplicationController
  include Pagy::Backend
  before_action :set_turma, only: %i[ show edit update destroy ]

  ##
  # Lista as turmas do usuário atual.
  #
  # Se o usuário for docente, traz as turmas que ele leciona. Caso contrário, traz as turmas onde ele é aluno.
  #
  # ==== Efeitos colaterais
  # Carrega @turmas para uso na view.
  def index
    if current_user.ocupacao == "docente"
      @turmas = Turma.includes(:docente).where(id_docente: current_user.id).order(:name)
    else
      @turmas = current_user.turmas_como_aluno.order(:name)
    end
  end

  ##
  # Exibe os detalhes de uma turma, incluindo alunos, formulários e busca de alunos.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID da turma a ser exibida
  # * +params[:q]+ - (opcional) termo de busca para alunos
  #
  # ==== Efeitos colaterais
  # Carrega dados da turma e resultados de busca para uso na view.
  def show
    @turma = Turma.includes(:docente, :formularios, :alunos).find(params[:id])
    @pagy_vinculados, @alunos_vinculados = pagy(@turma.alunos.order(:nome), items: 10, page_param: :page_vinculados)
    @formularios_com_respostas = @turma.formularios.includes(:respostas)

    if params[:q].present?
      termo = "%#{params[:q]}%"
      query = User.where("nome ILIKE :q OR email ILIKE :q OR matricula ILIKE :q", q: termo)
                  .where.not(id: @alunos_vinculados.pluck(:id))
                  .order(:nome)
      @pagy, @alunos_busca = pagy(query, items: 10)
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  ##
  # Inicializa uma nova instância de turma.
  def new
    @turma = Turma.new
  end

  ##
  # Edita os dados de uma turma existente.
  #
  # ==== Efeitos colaterais
  # Usa o método +set_turma+ para carregar a turma.
  def edit
  end

  ##
  # Cria uma nova turma com os parâmetros fornecidos.
  #
  # ==== Parâmetros
  # * +params[:turma]+ - hash com dados da turma
  #
  # ==== Efeitos colaterais
  # Salva no banco de dados e redireciona ou renderiza conforme sucesso ou erro.
  def create
    @turma = Turma.new(turma_params)

    respond_to do |format|
      if @turma.save
        format.html { redirect_to @turma, notice: "Turma criada com sucesso." }
        format.turbo_stream { redirect_to @turma }
        format.json { render :show, status: :created, location: @turma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end

  ##
  # Atualiza uma turma existente.
  #
  # ==== Parâmetros
  # * +params[:turma]+ - hash com dados atualizados da turma
  #
  # ==== Efeitos colaterais
  # Salva alterações no banco ou renderiza erros.
  def update
    respond_to do |format|
      if @turma.update(turma_params)
        format.html { redirect_to @turma, notice: "Turma was successfully updated." }
        format.json { render :show, status: :ok, location: @turma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end

  ##
  # Remove uma turma do banco de dados.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID da turma a ser deletada
  #
  # ==== Efeitos colaterais
  # Exclui do banco e redireciona para a listagem.
  def destroy
    @turma.destroy!

    respond_to do |format|
      format.html { redirect_to turmas_path, status: :see_other, notice: "Turma was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  ##
  # Busca alunos pelo nome, matrícula ou e-mail que ainda não estejam vinculados à turma.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID da turma
  # * +params[:query]+ - termo de busca
  #
  # ==== Efeitos colaterais
  # Renderiza um partial com os resultados.
  def buscar_alunos
    @turma = Turma.find(params[:id])
    @resultados = User.where("nome ILIKE :q OR matricula ILIKE :q OR email ILIKE :q", q: "%#{params[:query]}%")
                      .where.not(id: @turma.aluno_ids)
    render partial: "turmas/resultados_busca", locals: { resultados: @resultados, turma: @turma }
  end

  private

    ##
    # Carrega a turma com base no ID informado.
    #
    # ==== Parâmetros
    # * +params[:id]+ - ID da turma
    #
    # ==== Efeitos colaterais
    # Define a variável de instância @turma.
    def set_turma
      @turma = Turma.find(params[:id])
    end

    ##
    # Filtra e estrutura os parâmetros permitidos para criação/edição de turma.
    #
    # ==== Retorno
    # Hash com os dados válidos.
    def turma_params
      {
        name: params[:turma][:name],
        code: params[:turma][:code],
        id_docente: params[:turma][:id_docente].presence&.to_i,
        class_data: params[:class_data].permit(:classCode, :semester, :time).to_h
      }
    end
end
