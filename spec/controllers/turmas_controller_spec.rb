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

    it 'atribui busca vazia se termo não existir' do
      get :show, params: { id: turma.id, q: 'Inexistente' }
      expect(assigns(:alunos_busca)).to be_nil.or be_empty
    end
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

    it 'não cria turma se houver erro de validação' do
      invalid_params = valid_params.merge(name: nil)
      expect {
        post :create, params: { turma: invalid_params, class_data: invalid_params[:class_data] }
      }.not_to change(Turma, :count)
      expect(response).to render_template(:new)
      expect(response.status).to eq(422)
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

    it 'retorna erro se destroy falhar' do
    turma_erro = create(:turma, docente: docente)
    allow_any_instance_of(Turma).to receive(:destroy!).and_raise(StandardError, 'erro ao remover')
    expect {
        delete :destroy, params: { id: turma_erro.id }
    }.to raise_error(StandardError, /erro ao remover/)
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

    it 'retorna vazio se não houver resultados' do
      turma_busca = create(:turma, docente: docente)
      get :buscar_alunos, params: { id: turma_busca.id, query: 'Inexistente' }
      expect(assigns(:resultados)).to be_empty
    end
  end



  # ...existing code...
  # Mantido apenas a versão DRY dos specs usando shared_examples globais
end
