class TurmasAluno < ApplicationRecord
  belongs_to :turma, foreign_key: :turma_id
  belongs_to :aluno, class_name: 'User', foreign_key: :aluno_id
end