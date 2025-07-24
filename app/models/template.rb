##
# Modelo que representa um template de formulário.
#
# Cada instância desta classe define a estrutura de um formulário, incluindo quais campos e
# perguntas ele deve conter. A partir de um template, vários formulários (instâncias) podem ser
# criados e associados a diferentes usuários.
#
# ==== Atributos esperados
# * +id_user+ [Integer] - ID do usuário proprietário ou criador do template.
#
# ==== Associações
# * +user+ - Usuário que criou ou é dono do template.
# * +formularios+ - Coleção de formulários gerados a partir deste template.
#
# ==== Callbacks e dependências
# * A associação com +formularios+ possui a opção +dependent: :destroy+, o que significa que
#   ao excluir um template, todos os formulários relacionados a ele serão removidos do banco.
#
# ==== Exemplo de uso
#   template = Template.create!(id_user: 1)
#   template.formularios.create!(nome: "Formulário de Avaliação")
#
class Template < ApplicationRecord
  belongs_to :user, foreign_key: :id_user
  has_many :formularios, foreign_key: :id_template, dependent: :destroy

  validates :nome, presence: true
end
