class AddConteudoToRespostas < ActiveRecord::Migration[7.2]
  def change
    add_column :respostas, :conteudo, :text
  end
end
