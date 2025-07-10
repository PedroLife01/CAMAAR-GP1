class CreateTurmas < ActiveRecord::Migration[7.2]
  def change
    create_table :turmas do |t|
      t.string :code
      t.string :name
      t.jsonb :class_data
      t.integer :id_docente

      t.timestamps
    end
    
    add_foreign_key :turmas, :users, column: :id_docente
    add_index :turmas, :id_docente
  end
end
