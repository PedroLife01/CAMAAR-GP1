##
# Controller responsável por gerenciar as ações relacionadas às turmas.
#
# Permite realizar CRUD completo, visualizar alunos vinculados, formulários associados
# e realizar busca por alunos para vinculação.
class TurmasController < ApplicationController
  include Pagy::Backend
  before_action :set_turma, only: %i[ show edit update destroy ]

  ##
  # Lista as turmas associadas ao usuário atual.
  #
  # - Se for docente: lista as turmas em que é responsável.
  # - Se for discente: lista as turmas em que está matriculado.
  #
  # ==== Efeitos colaterais
  # Carrega @turmas para uso nas views.
  def index
    if current_user.ocupacao == "docente"
      @turmas = Turma.includes(:docente).where(id_docente: current_user.id).order(:name)
    else
      @turmas = current_user.turmas_como_aluno.order(:name)
    end
  end

  ##
  # Exibe os detalhes de uma turma específica.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID da turma a ser exibida.
  # * +params[:q]+ - (opcional) termo para busca de alunos.
  #
  # ==== Efeitos colaterais
  # Carrega variáveis: @turma, @alunos_vinculados, @formularios_com_respostas,
  # e @alunos_busca (caso haja busca ativa).
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
  # Instancia um novo objeto `Turma`.
  #
  # ==== Efeitos colaterais
  # Define @turma como uma nova instância.
  def new
    @turma = Turma.new
  end

  ##
  # Instancia a turma a ser editada.
  #
  # ==== Efeitos colaterais
  # Define @turma via +set_turma+.
  def edit
  end

  ##
  # Cria uma nova turma com os parâmetros fornecidos.
  #
  # ==== Parâmetros
  # * +params[:turma]+ - hash com os atributos da turma.
  #
  # ==== Retorno
  # Redireciona ou renderiza conforme sucesso ou erro.
  #
  # ==== Efeitos colaterais
  # Cria um novo registro de Turma no banco de dados.
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
  # Atualiza os dados de uma turma existente.
  #
  # ==== Parâmetros
  # * +params[:turma]+ - hash com os novos dados da turma.
  #
  # ==== Efeitos colaterais
  # Salva alterações no banco ou renderiza erro de validação.
  def update
    respond_to do |format|
      if @turma.update(turma_params)
        format.html { redirect_to @turma, notice: "Turma atualizada com sucesso." }
        format.json { render :show, status: :ok, location: @turma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end

  ##
  # Exclui uma turma do banco de dados.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID da turma a ser excluída.
  #
  # ==== Efeitos colaterais
  # Remove a turma e redireciona para a listagem com status 303.
  def destroy
    @turma.destroy!

    respond_to do |format|
      format.html { redirect_to turmas_path, status: :see_other, notice: "Turma excluída com sucesso." }
      format.json { head :no_content }
    end
  end

  ##
  # Busca alunos ainda não vinculados à turma, pelo nome, matrícula ou e-mail.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID da turma.
  # * +params[:query]+ - termo para busca.
  #
  # ==== Efeitos colaterais
  # Renderiza o partial `turmas/_resultados_busca.html.erb` com os resultados encontrados.
  def buscar_alunos
    @turma = Turma.find(params[:id])
    @resultados = User.where("nome ILIKE :q OR matricula ILIKE :q OR email ILIKE :q", q: "%#{params[:query]}%")
                      .where.not(id: @turma.aluno_ids)
    render partial: "turmas/resultados_busca", locals: { resultados: @resultados, turma: @turma }
  end

  private

    ##
    # Localiza a turma com base no ID informado.
    #
    # ==== Parâmetros
    # * +params[:id]+ - ID da turma.
    #
    # ==== Efeitos colaterais
    # Define a variável @turma.
    def set_turma
      @turma = Turma.find(params[:id])
    end

    ##
    # Permite apenas os parâmetros válidos para criação ou edição de turmas.
    #
    # ==== Retorno
    # Hash contendo os atributos permitidos: +name+, +code+, +id_docente+, +class_data+.
    def turma_params
      {
        name: params[:turma][:name],
        code: params[:turma][:code],
        id_docente: params[:turma][:id_docente].presence&.to_i,
        class_data: params[:class_data].permit(:classCode, :semester, :time).to_h
      }
    end
end
