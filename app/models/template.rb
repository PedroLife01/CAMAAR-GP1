##
# Modelo que representa a resposta de um aluno a uma pergunta de um formulário.
#
# Cada resposta pertence a um formulário e a um aluno (usuário com ocupação "dicente").
# Uma mesma pergunta não pode ser respondida mais de uma vez pelo mesmo aluno no mesmo formulário.
#
# ==== Associações
# * +formulario+ - Formulário ao qual a resposta pertence.
# * +aluno+ - Usuário que respondeu a pergunta.
#
# ==== Validações
# * Garante que um mesmo aluno não possa responder a mesma pergunta do mesmo formulário mais de uma vez.
class Resposta < ApplicationRecord
  belongs_to :formulario
  belongs_to :aluno, class_name: "User", foreign_key: "aluno_id"

  validates :aluno_id, uniqueness: { scope: [:formulario_id, :pergunta_index],
                                     message: "já respondeu essa pergunta do formulário" }
end
