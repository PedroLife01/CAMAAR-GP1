require 'rails_helper'

RSpec.describe TurmasAluno, type: :model do
  describe 'associations' do
    it { should belong_to(:turma) }
    it { should belong_to(:aluno).class_name('User').with_foreign_key(:aluno_id) }
  end


  describe 'integridade' do
    it 'não permite criar TurmasAluno sem turma ou aluno' do
      expect(TurmasAluno.new).not_to be_valid
      expect(TurmasAluno.new(turma_id: 1)).not_to be_valid
      expect(TurmasAluno.new(aluno_id: 1)).not_to be_valid
    end
  end
end
