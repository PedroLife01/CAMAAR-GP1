class AddNomeToTemplates < ActiveRecord::Migration[7.2]
  def change
    add_column :templates, :nome, :string
  end
end
