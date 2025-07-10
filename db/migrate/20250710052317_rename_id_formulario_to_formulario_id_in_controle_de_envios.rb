class RenameIdFormularioToFormularioIdInControleDeEnvios < ActiveRecord::Migration[7.2]
  def change
    rename_column :controle_de_envios, :id_formulario, :formulario_id
  end

end
