##
# Modelo que representa um formulário a ser respondido por alunos de uma turma.
#
# Cada formulário:
# - É criado por um docente.
# - Está associado a uma turma específica.
# - Usa um template que define sua estrutura de perguntas (em JSON).
# - Pode ter múltiplas respostas (de alunos) e registros de envio.
#
# ==== Atributos esperados
# * +titulo+ [String] - Título do formulário.
# * +descricao+ [Text] - Descrição opcional do formulário.
# * +data_abertura+ [DateTime] - Data/hora em que o formulário se torna disponível.
# * +data_fechamento+ [DateTime] - Data/hora em que o formulário fecha para respostas.
# * +id_template+ [Integer] - Chave estrangeira para o template associado.
# * +id_turma+ [Integer] - Chave estrangeira para a turma associada.
# * +id_docente+ [Integer] - Chave estrangeira para o usuário que criou o formulário.
#
# ==== Associações
# * +template+ - Template utilizado para definir as perguntas do formulário.
# * +turma+ - Turma para a qual o formulário será enviado.
# * +docente+ - Usuário que criou o formulário (ocupação: "docente").
# * +controle_de_envios+ - Registros de envio do formulário para os alunos.
# * +respostas+ - Respostas submetidas pelos alunos.
#
# ==== Exemplo de uso
#   Formulario.create!(
#     titulo: "Avaliação Parcial",
#     descricao: "Formulário de feedback",
#     data_abertura: Time.current,
#     data_fechamento: 5.days.from_now,
#     template: template,
#     turma: turma,
#     docente: current_user
#   )
#

class Formulario < ApplicationRecord
  belongs_to :template, foreign_key: :id_template
  belongs_to :turma, foreign_key: :id_turma
  belongs_to :docente, class_name: "User", foreign_key: :id_docente

  has_many :controle_de_envios, dependent: :destroy
  has_many :respostas, dependent: :destroy

  validates :titulo, :descricao, :data_abertura, :data_fechamento, :id_turma, :id_template, presence: true
end
