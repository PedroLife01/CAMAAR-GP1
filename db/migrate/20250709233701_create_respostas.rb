class CreateRespostas < ActiveRecord::Migration[7.2]
  def change
    create_table :respostas do |t|
      t.integer :id_formulario
      t.jsonb :respostas

      t.timestamps
    end
    add_foreign_key :respostas, :formularios, column: :id_formulario
    add_index :respostas, :id_formulario
  end
end
