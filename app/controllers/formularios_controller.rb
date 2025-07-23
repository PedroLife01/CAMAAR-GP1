##
# Controller responsável por gerenciar formulários criados por docentes.
#
# Permite criação, visualização, exclusão, envio e exportação de respostas dos formulários.
class FormulariosController < ApplicationController
  require "csv"
  before_action :authenticate_user!
  before_action :set_formulario, only: [:show, :destroy, :enviar]
  before_action :authorize_docente!, only: [:new, :create]

  ##
  # Lista os formulários disponíveis para o usuário atual.
  #
  # - Para docentes: lista formulários das suas turmas.
  # - Para discentes: lista os formulários ainda não respondidos.
  #
  # ==== Efeitos colaterais
  # Carrega a variável @formularios.
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

  ##
  # Exibe as respostas anônimas do formulário.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário
  #
  # ==== Efeitos colaterais
  # Requer permissão de docente. Carrega @respostas para a view.
  def respostas_anonimas
    @formulario = Formulario.find(params[:id])
    authorize_docente!

    @respostas = @formulario.respostas.order(:pergunta_index)
  end

  ##
  # Exclui um formulário.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário a ser excluído
  #
  # ==== Efeitos colaterais
  # Remove do banco de dados e redireciona com mensagem.
  def destroy
    if @formulario.destroy
      redirect_to formularios_path, notice: "Formulário excluído com sucesso! 🗑️"
    else
      redirect_to @formulario, alert: "Não foi possível excluir o formulário."
    end
  end

  ##
  # Exporta as respostas anônimas do formulário em formato CSV.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário
  #
  # ==== Efeitos colaterais
  # Envia um arquivo CSV como resposta.
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

  ##
  # Formulário para criação de novo formulário.
  #
  # ==== Efeitos colaterais
  # Carrega @turmas e @templates para a view.
  def new
    @formulario = Formulario.new
    @turmas = Turma.where(id_docente: current_user.id)
    @templates = Template.all
  end

  ##
  # Cria um novo formulário com os dados fornecidos.
  #
  # ==== Efeitos colaterais
  # Salva no banco e redireciona com mensagem de sucesso ou erro.
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

  ##
  # Exibe os detalhes de um formulário.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário
  def show
  end

  ##
  # Envia o formulário para todos os alunos da turma.
  #
  # ==== Efeitos colaterais
  # Cria registros em ControleDeEnvio.
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

  ##
  # Define o formulário com base no ID da URL.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário
  def set_formulario
    @formulario = Formulario.find(params[:id])
  end

  ##
  # Filtra os parâmetros permitidos para criação/edição de formulário.
  #
  # ==== Retorno
  # Hash com os campos permitidos.
  def formulario_params
    params.require(:formulario).permit(:titulo, :descricao, :data_abertura, :data_fechamento, :id_turma, :id_template)
  end

  ##
  # Garante que apenas usuários com ocupação "docente" possam acessar certos métodos.
  #
  # ==== Efeitos colaterais
  # Redireciona para root_path com alerta caso o usuário não seja docente.
  def authorize_docente!
    unless current_user&.ocupacao == "docente"
      redirect_to root_path, alert: "Apenas docentes podem criar formulários."
    end
  end
end
