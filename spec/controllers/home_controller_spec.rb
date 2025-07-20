
require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'
require_relative '../support/shared_examples/atribui_shared_examples'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    before { get :index }
    it 'renderiza o template index com sucesso' do
      expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end
end
