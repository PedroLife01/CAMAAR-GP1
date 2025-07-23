##
# Modelo de associação entre +Turma+ e +User+ (ocupação: "dicente").
#
# Representa o vínculo de um aluno com uma turma.
# Utilizado para consultas e manipulação do relacionamento N:N entre turmas e alunos.
#
# ==== Associações
# * +turma+ - Turma vinculada ao aluno.
# * +aluno+ - Usuário (discente) vinculado à turma.
class TurmasAluno < ApplicationRecord
  belongs_to :turma, foreign_key: :turma_id
  belongs_to :aluno, class_name: 'User', foreign_key: :aluno_id
end
