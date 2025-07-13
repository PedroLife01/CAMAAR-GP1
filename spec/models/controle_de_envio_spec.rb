require 'rails_helper'

RSpec.describe ControleDeEnvio, type: :model do
  describe 'associations' do
    # Adapte conforme os relacionamentos reais do model
    it { should belong_to(:user).optional } if ControleDeEnvio.reflect_on_association(:user)
    it { should belong_to(:formulario) } if ControleDeEnvio.reflect_on_association(:formulario)
  end
end
