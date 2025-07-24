##
# Controller responsável por gerenciar formulários criados por docentes.
#
# Permite criação, visualização, exclusão, envio e exportação de respostas dos formulários.
# Alunos (dicentes) visualizam apenas os formulários ainda não respondidos.
class FormulariosController < ApplicationController
  require "csv"

  before_action :authenticate_user!
  before_action :set_formulario, only: [:show, :destroy, :enviar]
  before_action :authorize_docente!, only: [:new, :create]

  ##
  # Lista os formulários visíveis ao usuário logado.
  #
  # ==== Regras
  # - Para docentes: exibe formulários das turmas que lecionam.
  # - Para discentes: exibe apenas os formulários que ainda não responderam.
  #
  # ==== Efeitos colaterais
  # Carrega a variável de instância +@formularios+.
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
  # Exibe respostas anônimas para um formulário, organizadas por pergunta.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário cujas respostas serão exibidas.
  #
  # ==== Efeitos colaterais
  # - Requer permissão de docente.
  # - Carrega +@respostas+ e +@formulario+ para a view.
  def respostas_anonimas
    @formulario = Formulario.find(params[:id])
    authorize_docente!

    @respostas = @formulario.respostas.order(:pergunta_index)
  end

  ##
  # Exclui um formulário da base de dados.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário a ser removido.
  #
  # ==== Efeitos colaterais
  # - Remove o registro permanentemente do banco.
  # - Redireciona com flash de sucesso ou erro.
  def destroy
    if @formulario.destroy
      redirect_to formularios_path, notice: "Formulário excluído com sucesso! 🗑️"
    else
      redirect_to @formulario, alert: "Não foi possível excluir o formulário."
    end
  end

  ##
  # Exporta as respostas anônimas do formulário em um arquivo CSV.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário a ser exportado.
  #
  # ==== Retorno
  # * Envia um arquivo CSV como resposta HTTP.
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
  # Formulário de criação de novo formulário.
  #
  # ==== Efeitos colaterais
  # Carrega variáveis +@turmas+ e +@templates+ para a view.
  def new
    @formulario = Formulario.new
    @turmas = Turma.where(id_docente: current_user.id)
    @templates = Template.all
  end

  ##
  # Cria um novo formulário a partir dos dados submetidos pelo docente.
  #
  # ==== Efeitos colaterais
  # - Salva o formulário no banco de dados.
  # - Redireciona para a página do formulário ou renderiza novamente com erro.
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
  # * +params[:id]+ - ID do formulário a ser visualizado.
  def show
  end

  ##
  # Envia o formulário para todos os alunos da turma associada.
  #
  # ==== Efeitos colaterais
  # - Cria registros na tabela +ControleDeEnvio+ para cada aluno da turma.
  # - Redireciona com aviso de sucesso.
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
  # Carrega o formulário com base no ID passado via params.
  #
  # ==== Parâmetros
  # * +params[:id]+ - ID do formulário.
  def set_formulario
    @formulario = Formulario.find(params[:id])
  end

  ##
  # Define os parâmetros permitidos para criação e edição de formulários.
  #
  # ==== Retorno
  # Hash de parâmetros seguros.
  def formulario_params
    params.require(:formulario).permit(
      :titulo,
      :descricao,
      :data_abertura,
      :data_fechamento,
      :id_turma,
      :id_template
    )
  end

  ##
  # Garante que o usuário atual seja um docente antes de executar certas ações.
  #
  # ==== Efeitos colaterais
  # Redireciona para +root_path+ com uma mensagem de alerta caso a ocupação não seja "docente".
  def authorize_docente!
    unless current_user&.ocupacao == "docente"
      redirect_to root_path, alert: "Apenas docentes podem criar formulários."
    end
  end
end
