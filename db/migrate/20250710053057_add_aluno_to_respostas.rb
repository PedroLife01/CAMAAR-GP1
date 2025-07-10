class AddAlunoToRespostas < ActiveRecord::Migration[7.2]
  def change
    add_reference :respostas, :aluno, null: false, foreign_key: { to_table: :users }
  end
end
