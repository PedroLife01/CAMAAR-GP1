class AdjustTurmasAlunosToRailsWay < ActiveRecord::Migration[7.2]
  def change
    rename_column :turmas_alunos, :id_turma, :turma_id
    rename_column :turmas_alunos, :id_aluno, :aluno_id

    remove_foreign_key :turmas_alunos, column: :turma_id
    remove_foreign_key :turmas_alunos, column: :aluno_id

    add_foreign_key :turmas_alunos, :turmas
    add_foreign_key :turmas_alunos, :users, column: :aluno_id
  end
end
