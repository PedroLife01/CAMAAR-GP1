class CreateControleDeEnvios < ActiveRecord::Migration[7.2]
  def change
    create_table :controle_de_envios do |t|
      t.integer :id_aluno
      t.integer :id_formulario
      t.boolean :is_envio

      t.timestamps
    end
    add_foreign_key :controle_de_envios, :users, column: :id_aluno
    add_foreign_key :controle_de_envios, :formularios, column: :id_formulario
    add_index :controle_de_envios, :id_aluno
    add_index :controle_de_envios, :id_formulario
  end
end
