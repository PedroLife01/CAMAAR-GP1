class RenameIdAlunoToAlunoIdInControleDeEnvios < ActiveRecord::Migration[7.2]
  def change
    rename_column :controle_de_envios, :id_aluno, :aluno_id
  end

end
