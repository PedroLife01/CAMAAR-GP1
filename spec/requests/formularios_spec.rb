require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:dicente) { create(:user, ocupacao: 'dicente') }
  let(:formulario_dicente) { create(:formulario) }

  before do
    sign_in dicente
  end

  describe "GET /formularios" do
    it "retorna sucesso" do
      get formularios_path
      expect(response).to have_http_status(:success)
    end
  end
end
