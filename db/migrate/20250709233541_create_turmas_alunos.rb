class CreateTurmasAlunos < ActiveRecord::Migration[7.2]
  def change
    create_table :turmas_alunos do |t|
      t.integer :id_turma
      t.integer :id_aluno

      t.timestamps
    end
    
    add_foreign_key :turmas_alunos, :turmas, column: :id_turma
    add_foreign_key :turmas_alunos, :users, column: :id_aluno
    add_index :turmas_alunos, :id_turma
    add_index :turmas_alunos, :id_aluno

  end
end
