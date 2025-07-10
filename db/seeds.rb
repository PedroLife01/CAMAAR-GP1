require 'json'

# Lê os arquivos JSON
turmas_data = JSON.parse(File.read(Rails.root.join('db/classes.json')))
membros_data = JSON.parse(File.read(Rails.root.join('db/class_members.json')))

# Limpa o banco
User.destroy_all
Turma.destroy_all
TurmasAluno.destroy_all

puts "Populando banco com dados reais..."

membros_data.each do |entrada|
  turma_info = turmas_data.find { |t| t["code"] == entrada["code"] }

  # Cria ou encontra o docente
  docente_data = entrada["docente"]
  docente = User.find_or_create_by!(email: docente_data["email"]) do |u|
    u.nome = docente_data["nome"].titleize
    u.curso = docente_data["departamento"]
    u.matricula = docente_data["usuario"]
    u.usuario = docente_data["usuario"]
    u.formacao = docente_data["formacao"]
    u.ocupacao = docente_data["ocupacao"]
    u.password = "123456"
  end

  # Cria a turma
  turma = Turma.create!(
    code: entrada["code"],
    name: turma_info["name"],
    class_data: turma_info["class"],
    id_docente: docente.id
  )

  # Cria os alunos e vincula à turma
  entrada["dicente"].each do |aluno_data|
    aluno = User.find_or_create_by!(email: aluno_data["email"]) do |u|
      u.nome = aluno_data["nome"].titleize
      u.curso = aluno_data["curso"]
      u.matricula = aluno_data["matricula"]
      u.usuario = aluno_data["usuario"]
      u.formacao = aluno_data["formacao"]
      u.ocupacao = aluno_data["ocupacao"]
      u.password = "123456"
    end

    TurmasAluno.create!(turma_id: turma.id, aluno_id: aluno.id)
  end

  puts "Turma #{turma.name} criada com #{entrada['dicente'].size} alunos."
end

puts "Seed finalizado com sucesso!"
