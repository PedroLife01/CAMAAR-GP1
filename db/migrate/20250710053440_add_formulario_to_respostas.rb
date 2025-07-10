class AddFormularioToRespostas < ActiveRecord::Migration[7.2]
  def change
    add_reference :respostas, :formulario, null: false, foreign_key: true
  end
end
