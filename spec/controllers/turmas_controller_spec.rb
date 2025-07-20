
require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'
require_relative '../support/shared_examples/atribui_shared_examples'

RSpec.describe TurmasController, type: :controller do
  let_it_be(:docente) { create(:user, ocupacao: 'docente') }
  let_it_be(:aluno)   { create(:user, ocupacao: 'dicente') }
  let_it_be(:turma)   { create(:turma, docente: docente) }

  before { sign_in docente }



  describe 'GET #index' do
    before { get :index }
    include_examples 'atribui coleção', :turmas, :index
  end

  describe 'GET #show' do
    before do
      turma.alunos << aluno
      get :show, params: { id: turma.id }
    end
    it 'atribui a turma e alunos vinculados' do
      expect(assigns(:alunos_vinculados)).to include(aluno)
    end
    include_examples 'atribui recurso', :turma, :show
  end

  describe 'GET #new' do
    before { get :new }
    include_examples 'atribui recurso', :turma, :new
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: turma.id } }
    include_examples 'atribui recurso', :turma, :edit
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        name: 'Nova Turma',
        code: 'TURMA2025',
        id_docente: docente.id,
        class_data: { classCode: 'C1', semester: '2025.1', time: '10h' }
      }
    end
    subject(:do_request) { post :create, params: { turma: valid_params, class_data: valid_params[:class_data] } }
    it 'cria uma nova turma e redireciona' do
      expect { do_request }.to change(Turma, :count).by(1)
      expect(response).to redirect_to(Turma.last)
      expect(flash[:notice]).to match(/criada com sucesso/i)
    end
  end
  describe 'PATCH #update' do
    let(:params) do
      {
        name: 'Turma Atualizada',
        code: 'TURMA2026',
        id_docente: docente.id,
        class_data: { classCode: 'C2', semester: '2026.1', time: '14h' }
      }
    end
    it 'atualiza a turma e redireciona' do
      patch :update, params: { id: turma.id, turma: params, class_data: params[:class_data] }
      turma.reload
      expect(turma.name).to eq('Turma Atualizada')
      expect(response).to redirect_to(turma)
    end
    it 'não atualiza com dados inválidos' do
      patch :update, params: { id: turma.id, turma: params.merge(name: nil), class_data: params[:class_data] }
      expect(response).to render_template(:edit)
      expect(response.status).to eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'remove a turma e redireciona' do
      turma_id = turma.id
      expect {
        delete :destroy, params: { id: turma_id }
      }.to change(Turma, :count).by(-1)
      expect(response).to redirect_to(turmas_path)
    end
  end

  describe 'GET #buscar_alunos' do
    it 'retorna resultados de busca de alunos' do
      turma_busca = create(:turma, docente: docente)
      aluno_busca = create(:user, nome: 'Fulano Busca', matricula: '123', email: 'fulano@teste.com', ocupacao: 'dicente')
      get :buscar_alunos, params: { id: turma_busca.id, query: 'Fulano' }
      expect(response).to render_template(partial: 'turmas/_resultados_busca')
      expect(assigns(:resultados)).to include(aluno_busca)
    end
  end

  describe 'GET #index para aluno' do
    before do
      sign_out docente
      sign_in aluno
      turma_aluno = create(:turma, docente: docente)
      turma_aluno.alunos << aluno
      get :index
      @turma_aluno = turma_aluno
    end
    it 'lista turmas do aluno' do
      expect(assigns(:turmas)).to include(@turma_aluno)
      expect(response).to render_template(:index)
    end
  end
end
require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'

RSpec.describe TurmasController, type: :controller do
  let_it_be(:docente) { create(:user, ocupacao: 'docente') }
  let_it_be(:aluno)   { create(:user, ocupacao: 'dicente') }
  let_it_be(:turma)   { create(:turma, docente: docente) }

  before { sign_in docente }

  shared_examples 'atribui turma' do |action|
    it "atribui a turma para #{action}" do
      expect(assigns(:turma)).to eq(turma)
      expect(response).to render_template(action)
    end
  end

  describe 'GET #index' do
    before { get :index }
    it 'lista turmas do docente' do
      expect(assigns(:turmas)).to include(turma)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before do
      turma.alunos << aluno
      get :show, params: { id: turma.id }
    end
    it 'atribui a turma e alunos vinculados' do
      expect(assigns(:alunos_vinculados)).to include(aluno)
      expect(response).to render_template(:show)
    end
    include_examples 'atribui turma', :show
  end

  describe 'GET #new' do
    before { get :new }
    it 'atribui uma nova turma' do
      expect(assigns(:turma)).to be_a_new(Turma)
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: turma.id } }
    include_examples 'atribui turma', :edit
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        name: 'Nova Turma',
        code: 'TURMA2025',
        id_docente: docente.id,
        class_data: { classCode: 'C1', semester: '2025.1', time: '10h' }
      }
    end
    subject(:do_request) { post :create, params: { turma: valid_params, class_data: valid_params[:class_data] } }
    it 'cria uma nova turma e redireciona' do
      expect { do_request }.to change(Turma, :count).by(1)
      expect(response).to redirect_to(Turma.last)
      expect(flash[:notice]).to match(/criada com sucesso/i)
    end
  end
end
