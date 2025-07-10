class CreateFormularios < ActiveRecord::Migration[7.2]
  def change
    create_table :formularios do |t|
      t.integer :id_template
      t.integer :id_turma

      t.timestamps
    end
    add_foreign_key :formularios, :templates, column: :id_template
    add_foreign_key :formularios, :turmas, column: :id_turma
    add_index :formularios, :id_template
    add_index :formularios, :id_turma
  end
end
