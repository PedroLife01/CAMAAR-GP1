require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'

RSpec.describe TemplatesController, type: :controller do
  let_it_be(:docente) { create(:user, ocupacao: 'docente') }
  let_it_be(:template) { create(:template, user: docente, nome: 'Template Teste', formulario: { 'perguntas' => [{ 'texto' => 'Pergunta?' }] }) }

  before { sign_in docente }

  shared_examples 'atribui template' do |action|
    it "atribui o template para #{action}" do
      expect(assigns(:template)).to eq(template)
      expect(response).to render_template(action)
    end
  end

  describe 'GET #index' do
    before { get :index }
    it 'atribui todos os templates ordenados' do
      expect(assigns(:templates)).to include(template)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: template.id } }
    include_examples 'atribui template', :show
  end

  describe 'GET #new' do
    before { get :new }
    it 'atribui um novo template' do
      expect(assigns(:template)).to be_a_new(Template)
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

  describe 'GET #edit' do
    before { get :edit, params: { id: template.id } }
    include_examples 'atribui template', :edit
  end

  describe 'DELETE #destroy' do
    it 'exclui o template e redireciona' do
      template
      expect {
        delete :destroy, params: { id: template.id }
      }.to change(Template, :count).by(-1)
      expect(response).to redirect_to(templates_path)
      expect(flash[:notice]).to match(/excluído com sucesso/i)
    end
  end

  describe 'restrições de uso' do
    it 'impede edição/exclusão se em uso' do
      t = create(:template, user: docente, nome: 'Restrito', formulario: { 'perguntas' => [{ 'texto' => 'Pergunta?' }] })
      allow_any_instance_of(Template).to receive_message_chain(:formularios, :exists?).and_return(true)
      get :edit, params: { id: t.id }
      expect(response).to redirect_to(templates_path)
      expect(flash[:alert]).to match(/não pode ser alterado/i)
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
require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'

RSpec.describe TemplatesController, type: :controller do
  let_it_be(:docente) { create(:user, ocupacao: 'docente') }
  let_it_be(:template) { create(:template, user: docente, nome: 'Template Teste', formulario: { 'perguntas' => [{ 'texto' => 'Pergunta?' }] }) }

  before { sign_in docente }

  shared_examples 'atribui template' do |action|
    it "atribui o template para #{action}" do
      expect(assigns(:template)).to eq(template)
      expect(response).to render_template(action)
    end
  end

  describe 'GET #index' do
    before { get :index }
    it 'atribui todos os templates ordenados' do
      expect(assigns(:templates)).to include(template)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: template.id } }
    include_examples 'atribui template', :show
  end

  describe 'GET #new' do
    before { get :new }
    it 'atribui um novo template' do
      expect(assigns(:template)).to be_a_new(Template)
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

  describe 'GET #edit' do
    before { get :edit, params: { id: template.id } }
    include_examples 'atribui template', :edit
  end

  describe 'DELETE #destroy' do
    it 'exclui o template e redireciona' do
      template
      expect {
        delete :destroy, params: { id: template.id }
      }.to change(Template, :count).by(-1)
      expect(response).to redirect_to(templates_path)
      expect(flash[:notice]).to match(/excluído com sucesso/i)
    end
  end

  describe 'restrições de uso' do
    it 'impede edição/exclusão se em uso' do
      t = create(:template, user: docente, nome: 'Restrito', formulario: { 'perguntas' => [{ 'texto' => 'Pergunta?' }] })
      allow_any_instance_of(Template).to receive_message_chain(:formularios, :exists?).and_return(true)
      get :edit, params: { id: t.id }
      expect(response).to redirect_to(templates_path)
      expect(flash[:alert]).to match(/não pode ser alterado/i)
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
