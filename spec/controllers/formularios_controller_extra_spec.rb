require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'


RSpec.describe FormulariosController, type: :controller do
  let(:docente) { create(:user, ocupacao: 'docente') }
  let(:aluno)   { create(:user, ocupacao: 'dicente') }
  let(:turma)   { create(:turma, id_docente: docente.id) }
  let(:template) { create(:template) }
  let!(:formulario) { create(:formulario, docente: docente, turma: turma, template: template) }

  before { sign_in docente }

  describe 'GET #index' do
    context 'quando usuário é docente' do
      before do
        turma # garante que a turma existe e pertence ao docente
        formulario # garante que o formulário pertence à turma do docente
        get :index
      end
      it 'atribui apenas formulários das turmas do docente' do
        expect(assigns(:formularios)).to include(formulario)
        expect(assigns(:formularios).map(&:id_turma)).to include(turma.id)
        expect(response).to render_template(:index)
      end
    end

    context 'quando usuário é dicente' do
      before do
        sign_out docente
        sign_in aluno
        turma.alunos << aluno
        ControleDeEnvio.create!(aluno: aluno, formulario: formulario)
        Resposta.create!(aluno: aluno, formulario: formulario, conteudo: 'ok', pergunta_index: 0)
        get :index
      end
      it 'atribui apenas formulários não respondidos' do
        expect(assigns(:formularios)).not_to include(formulario)
      end
    end
  end

  describe 'GET #respostas_anonimas' do
    let!(:resposta) { create(:resposta, formulario: formulario, pergunta_index: 1) }
    before { get :respostas_anonimas, params: { id: formulario.id } }
    it 'atribui respostas ordenadas e exige autorização' do
      expect(assigns(:respostas)).to include(resposta)
      expect(assigns(:respostas).map(&:formulario_id).uniq).to eq([formulario.id])
      expect(response).to render_template(:respostas_anonimas)
    end
  end

  describe 'DELETE #destroy' do
    it 'exclui o formulário e redireciona' do
      formulario
      expect {
        delete :destroy, params: { id: formulario.id }
      }.to change(Formulario, :count).by(-1)
      expect(response).to redirect_to(formularios_path)
      expect(flash[:notice]).to match(/excluído com sucesso/i)
    end
    it 'redireciona com erro se não conseguir excluir' do
      f = create(:formulario, docente: docente, turma: turma, template: template)
      allow_any_instance_of(Formulario).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: f.id }
      expect(response).to redirect_to(f)
      expect(flash[:alert]).to match(/não foi possível/i)
    end
  end

  describe 'GET #exportar_respostas_anonimas' do
    it 'exporta respostas em CSV' do
      allow_any_instance_of(Template).to receive(:formulario).and_return({ 'perguntas' => [{ 'texto' => 'Pergunta 1' }] })
      f = create(:formulario, docente: docente, turma: turma, template: template)
      create(:resposta, formulario: f, pergunta_index: 0, conteudo: 'Resposta')
      get :exportar_respostas_anonimas, params: { id: f.id }
      expect(response.header['Content-Type']).to include 'text/csv'
      expect(response.body).to include 'Pergunta 1'
      expect(response.body).to include 'Resposta'
    end
  end
end
