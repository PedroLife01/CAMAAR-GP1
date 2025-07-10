class Turma < ApplicationRecord
  # Docente responsável
  belongs_to :docente, class_name: 'User', foreign_key: :id_docente

  # Alunos vinculados
  has_many :turmas_alunos, dependent: :destroy
  has_many :alunos, through: :turmas_alunos, source: :aluno

  # Formularios associados
  has_many :formularios, foreign_key: :id_turma, dependent: :destroy

  def periodo
    class_data.to_s[/semester\s+([\w.]+)/, 1] || "Não informado"
  end

  def horario
    class_data.to_s[/time\s+([\w\d]+)/, 1] || "Não informado"
  end

  def codigo_classe
    class_data.to_s[/classCode\s+(\w+)/, 1] || "Não informado"
  end

end
