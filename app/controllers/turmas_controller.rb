class TurmasController < ApplicationController
  include Pagy::Backend
  before_action :set_turma, only: %i[ show edit update destroy ]

  # GET /turmas or /turmas.json
  def index
    if current_user.ocupacao == "docente"
      @turmas = Turma.includes(:docente).where(id_docente: current_user.id).order(:name)
    else
      @turmas = current_user.turmas_como_aluno.order(:name)
    end
  end

  # GET /turmas/1 or /turmas/1.json
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





  # GET /turmas/new
  def new
    @turma = Turma.new
  end

  # GET /turmas/1/edit
  def edit
  end

  # POST /turmas or /turmas.json
  def create
    @turma = Turma.new(turma_params)

    respond_to do |format|
      if @turma.save
        format.html { redirect_to @turma, notice: "Turma criada com sucesso." }
        format.turbo_stream { redirect_to @turma } # ✅ importante!
        format.json { render :show, status: :created, location: @turma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.json { render json: @turma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /turmas/1 or /turmas/1.json
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

  # DELETE /turmas/1 or /turmas/1.json
  def destroy
    @turma.destroy!

    respond_to do |format|
      format.html { redirect_to turmas_path, status: :see_other, notice: "Turma was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def buscar_alunos
    @turma = Turma.find(params[:id])
    @resultados = User.where("nome ILIKE :q OR matricula ILIKE :q OR email ILIKE :q", q: "%#{params[:query]}%")
                      .where.not(id: @turma.aluno_ids)
    render partial: "turmas/resultados_busca", locals: { resultados: @resultados, turma: @turma }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_turma
      @turma = Turma.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def turma_params
      {
        name: params[:turma][:name],
        code: params[:turma][:code],
        id_docente: params[:turma][:id_docente].presence&.to_i,
        class_data: params[:class_data].permit(:classCode, :semester, :time).to_h
      }
    end

end
