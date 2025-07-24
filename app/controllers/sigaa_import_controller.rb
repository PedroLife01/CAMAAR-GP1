##
# Controller responsável pela importação de dados do SIGAA (turmas, docentes e discentes).
#
# Essa importação é feita a partir de dois arquivos JSON:
# - Um com informações das turmas (code, nome, etc.)
# - Outro com informações de participantes (docente e alunos vinculados)
#
# Apenas usuários com perfil de docente ou admin podem acessar esta funcionalidade.
class SigaaImportController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_docente!

  ##
  # Renderiza o formulário de importação SIGAA.
  #
  # ==== Efeitos colaterais
  # Nenhum. Apenas exibe a view `sigaa_import/new.html.erb`.
  def new; end

  ##
  # Processa os arquivos de turmas e membros, e importa os dados para o banco.
  #
  # ==== Parâmetros
  # * +params[:classes_file]+ - Arquivo `.json` contendo as informações das turmas.
  # * +params[:members_file]+ - Arquivo `.json` contendo os docentes e discentes vinculados a cada turma.
  #
  # ==== Efeitos colaterais
  # - Cria ou atualiza usuários do tipo docente e dicente.
  # - Cria ou atualiza turmas com base no código (code) e docente.
  # - Cria vínculos entre alunos e turmas na tabela `turmas_alunos`.
  #
  # ==== Retornos
  # * Redireciona com sucesso se a importação for concluída sem erros.
  # * Redireciona com alerta em caso de ausência de arquivos ou erro de execução.
  #
  # ==== Tratamento de exceções
  # Usa uma transação para garantir integridade; se algum erro ocorrer,
  # a transação é revertida e uma mensagem de erro é exibida.
  def create
    classes_file = params[:classes_file]
    members_file = params[:members_file]

    if classes_file.blank? || members_file.blank?
      redirect_to sigaa_importar_path, alert: "Você precisa enviar os dois arquivos JSON."
      return
    end

    classes_data = JSON.parse(classes_file.read)
    members_data = JSON.parse(members_file.read)

    ActiveRecord::Base.transaction do
      members_data.each do |entry|
        turma_info = classes_data.find { |t| t["code"] == entry["code"] }

        # Processa o docente da turma
        docente_info = entry["docente"]
        docente = User.find_or_initialize_by(email: docente_info["email"])
        docente.update!(
          nome: docente_info["nome"].titleize,
          curso: docente_info["departamento"],
          matricula: docente_info["usuario"],
          usuario: docente_info["usuario"],
          formacao: docente_info["formacao"],
          ocupacao: "docente",
          password: docente.encrypted_password.present? ? docente.password : "123456"
        )

        # Cria ou atualiza a turma
        turma = Turma.find_or_create_by!(
          code: entry["code"],
          id_docente: docente.id
        ) do |t|
          t.name = turma_info["name"]
          t.class_data = turma_info["class"]
        end

        # Importa os alunos vinculados à turma
        entry["dicente"].each do |aluno_info|
          aluno = User.find_or_initialize_by(email: aluno_info["email"])
          aluno.update!(
            nome: aluno_info["nome"].titleize,
            curso: aluno_info["curso"],
            matricula: aluno_info["matricula"],
            usuario: aluno_info["usuario"],
            formacao: aluno_info["formacao"],
            ocupacao: "dicente",
            password: aluno.encrypted_password.present? ? aluno.password : "123456"
          )

          TurmasAluno.find_or_create_by!(turma_id: turma.id, aluno_id: aluno.id)
        end
      end
    end

    redirect_to sigaa_importar_path, notice: "Importação concluída com sucesso! 🎉"
  rescue => e
    redirect_to sigaa_importar_path, alert: "Erro na importação: #{e.message}"
  end

  private

  ##
  # Verifica se o usuário tem permissão de acesso (docente ou admin).
  #
  # ==== Efeitos colaterais
  # Redireciona para a home com mensagem de alerta se o acesso for negado.
  def authorize_docente!
    unless current_user.ocupacao == "docente" || current_user.ocupacao == "admin"
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
