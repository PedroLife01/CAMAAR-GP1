class ControleDeEnvio < ApplicationRecord
  belongs_to :aluno, class_name: 'User', foreign_key: :aluno_id
  belongs_to :formulario
end
