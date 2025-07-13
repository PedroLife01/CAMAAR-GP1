require 'rails_helper'

RSpec.describe Resposta, type: :model do
  describe 'associations' do
    # Adapte conforme os relacionamentos reais do model
    it { should belong_to(:formulario) } if Resposta.reflect_on_association(:formulario)
    it { should belong_to(:user).optional } if Resposta.reflect_on_association(:user)
  end
end
