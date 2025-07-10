class AddIdDocenteToFormularios < ActiveRecord::Migration[7.2]
  def change
    add_column :formularios, :id_docente, :integer
  end
end
