class CreateTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :templates do |t|
      t.integer :id_user
      t.jsonb :formulario

      t.timestamps
    end
    add_foreign_key :templates, :users, column: :id_user
    add_index :templates, :id_user
  end
end
