class Resposta < ApplicationRecord
  belongs_to :formulario
  belongs_to :aluno, class_name: "User", foreign_key: "aluno_id"

  validates :aluno_id, uniqueness: { scope: [:formulario_id, :pergunta_index],
                                     message: "já respondeu essa pergunta do formulário" }
end
