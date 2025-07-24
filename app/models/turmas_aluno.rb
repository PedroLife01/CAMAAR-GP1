##
# Modelo de associação entre +Turma+ e +User+ (ocupação: "dicente").
#
# Representa o vínculo de um aluno com uma turma.
# Utilizado para consultas e manipulação do relacionamento N:N entre turmas e alunos.
#
# ==== Associações
# * +turma+ - Turma vinculada ao aluno.
# * +aluno+ - Usuário (discente) vinculado à turma.
#
# ==== Observações
# Esta tabela associativa é usada para:
# - Consultar todos os alunos de uma turma via `turma.alunos`
# - Consultar todas as turmas de um aluno via `aluno.turmas_como_aluno`
class TurmasAluno < ApplicationRecord
  belongs_to :turma, foreign_key: :turma_id
  belongs_to :aluno, class_name: 'User', foreign_key: :aluno_id
end
