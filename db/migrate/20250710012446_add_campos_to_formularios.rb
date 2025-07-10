class AddCamposToFormularios < ActiveRecord::Migration[7.2]
  def change
    add_column :formularios, :titulo, :string
    add_column :formularios, :descricao, :text
    add_column :formularios, :data_abertura, :datetime
    add_column :formularios, :data_fechamento, :datetime
  end
end
