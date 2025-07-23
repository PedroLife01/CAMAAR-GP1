##
# Modelo que representa um formulário a ser respondido por alunos de uma turma.
#
# Um formulário pertence a uma turma, a um docente (usuário) e a um template que define sua estrutura.
# Ele pode ter várias respostas e registros de envio associados.
#
# ==== Associações
# * +template+ - Template utilizado para definir as perguntas do formulário.
# * +turma+ - Turma para a qual o formulário será enviado.
# * +docente+ - Usuário que criou o formulário (ocupação: "docente").
# * +controle_de_envios+ - Registros de envio do formulário para os alunos.
# * +respostas+ - Respostas submetidas pelos alunos.
class Formulario < ApplicationRecord
  belongs_to :template, foreign_key: :id_template
  belongs_to :turma, foreign_key: :id_turma
  belongs_to :docente, class_name: "User", foreign_key: :id_docente

  has_many :controle_de_envios, dependent: :destroy
  has_many :respostas, dependent: :destroy
end
