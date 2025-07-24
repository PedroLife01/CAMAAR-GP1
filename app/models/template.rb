##
# Modelo que representa a resposta de um aluno a uma pergunta de um formulário.
#
# Cada instância representa a resposta de um aluno a uma pergunta específica (indexada)
# dentro de um formulário. Um formulário pode conter várias perguntas, e cada uma delas
# será respondida individualmente por registros separados.
#
# ==== Atributos esperados
# * +formulario_id+ [Integer] - ID do formulário ao qual a resposta pertence.
# * +aluno_id+ [Integer] - ID do aluno que respondeu.
# * +pergunta_index+ [Integer] - Índice da pergunta no array de perguntas do template.
# * +conteudo+ [Text] - Conteúdo da resposta fornecida pelo aluno.
#
# ==== Associações
# * +formulario+ - Formulário ao qual a resposta pertence.
# * +aluno+ - Usuário que respondeu a pergunta (ocupação: "dicente").
#
# ==== Validações
# * Garante que um mesmo aluno não possa responder a mesma pergunta de um mesmo formulário mais de uma vez.
#   Essa restrição é aplicada pela combinação de `aluno_id`, `formulario_id` e `pergunta_index`.
#
# ==== Exemplo de uso
#   Resposta.create!(
#     formulario_id: 1,
#     aluno_id: 42,
#     pergunta_index: 0,
#     conteudo: "Acredito que a disciplina poderia ter mais atividades práticas."
#   )
#
class Resposta < ApplicationRecord
  belongs_to :formulario
  belongs_to :aluno, class_name: "User", foreign_key: "aluno_id"

  validates :aluno_id, uniqueness: { scope: [:formulario_id, :pergunta_index],
                                     message: "já respondeu essa pergunta do formulário" }
end
