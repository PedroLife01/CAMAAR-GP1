require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'associations' do
    it { should belong_to(:user).with_foreign_key(:id_user) }
    it { should have_many(:formularios).with_foreign_key(:id_template).dependent(:destroy) }
  end

  describe 'dependent destroy' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password') }
    let(:template) { Template.create!(user: user) }
    let(:turma) { Turma.create!(id_docente: user.id) }

    it 'destroys associated formularios when template is destroyed' do
      formulario = Formulario.create!(
        id_template: template.id,
        turma: turma,
        id_docente: user.id
      )
      expect { template.destroy }.to change { Formulario.count }.by(-1)
    end
  end
end