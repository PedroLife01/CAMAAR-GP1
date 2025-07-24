require 'rails_helper'

RSpec.describe ControleDeEnvio, type: :model do
  describe 'associações' do
    it { should belong_to(:aluno).class_name('User').with_foreign_key(:aluno_id) }
    it { should belong_to(:formulario) }
  end
end
