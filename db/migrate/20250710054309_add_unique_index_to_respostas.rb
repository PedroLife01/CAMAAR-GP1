class AddUniqueIndexToRespostas < ActiveRecord::Migration[7.2]
  def change
    add_index :respostas, [:formulario_id, :aluno_id, :pergunta_index], unique: true, name: "index_respostas_unicas"
  end
end
