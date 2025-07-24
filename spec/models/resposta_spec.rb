require 'rails_helper'

RSpec.describe Resposta, type: :model do
  describe 'associações' do
    it { should belong_to(:formulario) }
    it { should belong_to(:aluno).class_name('User').with_foreign_key('aluno_id') }
  end

  describe 'validações' do
    subject { build(:resposta) }
    it { should validate_uniqueness_of(:aluno_id).scoped_to([:formulario_id, :pergunta_index]).with_message('já respondeu essa pergunta do formulário') }
  end
end
