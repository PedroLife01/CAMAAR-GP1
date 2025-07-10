class Template < ApplicationRecord
  belongs_to :user, foreign_key: :id_user
  has_many :formularios, foreign_key: :id_template, dependent: :destroy

end
