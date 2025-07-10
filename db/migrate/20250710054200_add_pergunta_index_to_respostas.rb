class AddPerguntaIndexToRespostas < ActiveRecord::Migration[7.2]
  def change
    add_column :respostas, :pergunta_index, :integer
  end
end
