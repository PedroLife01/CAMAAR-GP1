##
# Controller responsável pela importação de dados do SIGAA (turmas, docentes e discentes).
#
# Permite que docentes (ou admins) importem turmas e seus participantes a partir de arquivos JSON.
class SigaaImportController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_docente!

  ##
  # Renderiza a página com o formulário de importação de arquivos SIGAA.
  #
  # ==== Efeitos colaterais
  # Nenhum. Apenas renderiza a view `sigaa_import/new.html.erb`.
  def new; end

  ##
  # Processa os arquivos enviados e realiza a importação de dados no banco.
  #
  # ==== Parâmetros
  # * +params[:classes_file]+ - Arquivo JSON com os dados das turmas.
  # * +params[:members_file]+ - Arquivo JSON com os dados dos participantes (docente + discentes).
  #
  # ==== Efeitos colaterais
  # - Cria ou atualiza usuários (docentes e discentes).
  # - Cria ou atualiza turmas.
  # - Cria vínculos entre alunos e turmas.
  #
  # ==== Tratamento de erros
  # - Caso arquivos estejam ausentes ou ocorra erro na transação, redireciona com alerta.
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

        turma = Turma.find_or_create_by!(
          code: entry["code"],
          id_docente: docente.id
        ) do |t|
          t.name = turma_info["name"]
          t.class_data = turma_info["class"]
        end

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
  # Garante que apenas docentes ou admins possam acessar a funcionalidade de importação.
  #
  # ==== Efeitos colaterais
  # Redireciona com alerta caso o usuário não seja autorizado.
  def authorize_docente!
    unless current_user.ocupacao == "docente" || current_user.ocupacao == "admin"
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
