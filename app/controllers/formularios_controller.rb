class FormulariosController < ApplicationController
  require "csv"
  before_action :authenticate_user!
  before_action :set_formulario, only: [:show, :destroy, :enviar]
  before_action :authorize_docente!, only: [:new, :create]

  def index
    if current_user.ocupacao == "docente"
      turmas_ids = Turma.where(id_docente: current_user.id).pluck(:id)

      @formularios = Formulario
        .includes(:turma, :template)
        .where(id_turma: turmas_ids)
    else
      respondidos_ids = Resposta.where(aluno_id: current_user.id).pluck(:formulario_id)

      @formularios = current_user.controle_de_envios
        .includes(:formulario)
        .map(&:formulario)
        .reject { |f| respondidos_ids.include?(f.id) }
    end
  end

  def respostas_anonimas
    @formulario = Formulario.find(params[:id])
    authorize_docente!

    @respostas = @formulario.respostas.order(:pergunta_index)
  end

  def destroy
    if @formulario.destroy
      redirect_to formularios_path, notice: "Formulário excluído com sucesso! 🗑️"
    else
      redirect_to @formulario, alert: "Não foi possível excluir o formulário."
    end
  end

  def exportar_respostas_anonimas
    @formulario = Formulario.find(params[:id])
    perguntas = @formulario.template.formulario["perguntas"]
    respostas = @formulario.respostas.group_by(&:pergunta_index)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << perguntas.each_with_index.map { |p, i| "#{i + 1}. #{p['texto']}" }

      max_respostas = respostas.values.map(&:size).max || 0

      max_respostas.times do |i|
        row = perguntas.each_index.map do |idx|
          respostas[idx][i]&.conteudo
        end
        csv << row
      end
    end

    send_data csv_data, filename: "respostas_formulario_#{@formulario.id}.csv"
  end


  def new
    @formulario = Formulario.new
    @turmas = Turma.where(id_docente: current_user.id)
    @templates = Template.all
  end

  def create
    @formulario = Formulario.new(formulario_params)
    @formulario.docente = current_user

    if @formulario.save
      redirect_to @formulario, notice: "Formulário criado com sucesso! 🎉"
    else
      @turmas = Turma.where(id_docente: current_user.id)
      @templates = Template.all
      flash.now[:alert] = "Erro ao criar formulário 🥲"
      render :new
    end
  end

  def show
  end

  def enviar
    turma = @formulario.turma
    alunos = turma.alunos.where(ocupacao: "dicente")

    alunos.each do |aluno|
      ControleDeEnvio.find_or_create_by!(aluno_id: aluno.id, formulario_id: @formulario.id) do |envio|
        envio.is_envio = true
      end
    end

    redirect_to formulario_path(@formulario), notice: "Formulário enviado com sucesso aos alunos da turma!"
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:id])
  end

  def formulario_params
    params.require(:formulario).permit(:titulo, :descricao, :data_abertura, :data_fechamento, :id_turma, :id_template)
  end

  def authorize_docente!
    unless current_user&.ocupacao == "docente"
      redirect_to root_path, alert: "Apenas docentes podem criar formulários."
    end
  end
end
