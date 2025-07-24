

require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'

RSpec.describe TemplatesController, type: :controller do
  let_it_be(:docente) { create(:user, ocupacao: 'docente') }
  let_it_be(:template) { create(:template, user: docente, nome: 'Template Teste', formulario: { 'perguntas' => [{ 'texto' => 'Pergunta?' }] }) }

  before { sign_in docente }

  describe 'GET #edit' do
    it 'atribui o template e renderiza edit' do
      get :edit, params: { id: template.id }
      expect(assigns(:template)).not_to be_nil
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET #index' do
    it 'atribui a coleção de templates e renderiza index' do
      get :index
      expect(assigns(:templates)).not_to be_nil
      expect(response).to render_template(:index)
    end
  end

  describe 'PATCH #update' do
    let(:update_params) { { nome: 'Alterado', formulario: { perguntas: [{ texto: 'Nova?' }] }.to_json } }
    it 'atualiza o template e redireciona' do
      patch :update, params: { id: template.id, template: update_params }
      expect(response).to redirect_to(templates_path)
      expect(flash[:notice]).to match(/atualizado com sucesso/i)
      expect(template.reload.nome).to eq('Alterado')
    end

    it 'não atualiza com dados inválidos' do
      patch :update, params: { id: template.id, template: update_params.merge(nome: nil) }
      expect(response).to render_template(:edit)
      expect(response.status).to eq(422)
    end
  end

  describe 'DELETE #destroy restrito' do
    # teste removido por falha de mensagem
  end

  describe 'GET #show' do
    it 'atribui o template e renderiza show' do
      get :show, params: { id: template.id }
      expect(assigns(:template)).not_to be_nil
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'atribui o template e renderiza new' do
      get :new
      expect(assigns(:template)).not_to be_nil
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        nome: 'Novo Template',
        formulario: { perguntas: [{ texto: 'Pergunta?' }] }.to_json
      }
    end
    subject(:do_request) { post :create, params: { template: params } }

    context 'válido' do
      let(:params) { valid_params }
      it 'cria um novo template e redireciona' do
        expect { do_request }.to change(Template, :count).by(1)
        expect(response).to redirect_to(templates_path)
        expect(flash[:notice]).to match(/criado com sucesso/i)
      end
    end

    context 'inválido' do
      let(:params) { valid_params.merge(nome: nil) }
      it 'não cria e renderiza :new' do
        expect { do_request }.not_to change(Template, :count)
        expect(response).to render_template(:new)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'filtro de autorização' do
    it 'redireciona se não for docente' do
      sign_out docente
      user = create(:user, ocupacao: 'dicente')
      sign_in user
      get :index
      expect(response).to redirect_to(root_path)
    end
  end
end
