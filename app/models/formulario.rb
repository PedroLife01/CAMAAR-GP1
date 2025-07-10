class Formulario < ApplicationRecord
  belongs_to :template, foreign_key: :id_template
  belongs_to :turma, foreign_key: :id_turma
  belongs_to :docente, class_name: "User", foreign_key: :id_docente

  has_many :controle_de_envios, dependent: :destroy
  has_many :respostas, dependent: :destroy
end
