require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'associations' do
    it { should belong_to(:user).with_foreign_key(:id_user) }
    it { should have_many(:formularios).with_foreign_key(:id_template).dependent(:destroy) }
  end

  describe 'dependent destroy' do
    it 'destroys associated formularios when template is destroyed' do
      template = create(:template)
      formulario = create(:formulario, template: template)
      expect { template.destroy }.to change(Formulario, :count).by(-1)
    end
  end
end