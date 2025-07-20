require 'rails_helper'

RSpec.describe TurmasAluno, type: :model do
  describe 'associações' do
    it { should belong_to(:turma).with_foreign_key(:turma_id) }
    it { should belong_to(:aluno).class_name('User').with_foreign_key(:aluno_id) }
  end
end
