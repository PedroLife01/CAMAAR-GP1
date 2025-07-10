class CreateResposta < ActiveRecord::Migration[7.2]
  def change
    create_table :resposta do |t|
      t.integer :id_formulario
      t.jsonb :respostas

      t.timestamps
    end
  end
end
