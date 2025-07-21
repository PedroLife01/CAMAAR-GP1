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
      it 'atribui apenas os formulários das turmas do docente' do
        get :index
        expect(assigns(:formularios)).to all(have_attributes(turma: turma))
      end
    end

    context 'quando usuário é dicente' do
      before do
        sign_out docente
        sign_in aluno
        allow(aluno).to receive(:controle_de_envios).and_return([])
        allow(Resposta).to receive(:where).and_return(double(pluck: []))
      end
      it 'atribui apenas os formulários não respondidos pelo aluno' do
        get :index
        expect(assigns(:formularios)).to be_a(Array)
      end
    end
  end



  describe 'GET #respostas_anonimas' do
    it 'atribui respostas ordenadas e exige autorização de docente' do
      get :respostas_anonimas, params: { id: formulario.id }
      expect(assigns(:respostas)).to eq(formulario.respostas.order(:pergunta_index))
    end

    it 'nega acesso se não for docente' do
      sign_out docente
      sign_in aluno
      get :respostas_anonimas, params: { id: formulario.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match(/Apenas docentes/i)
    end
  end



  describe 'DELETE #destroy' do
    it 'exclui o formulário com sucesso' do
      expect {
        delete :destroy, params: { id: formulario.id }
      }.to change(Formulario, :count).by(-1)
      expect(response).to redirect_to(formularios_path)
      expect(flash[:notice]).to match(/excluído com sucesso/i)
    end

    it 'não exclui se houver erro' do
      allow_any_instance_of(Formulario).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: formulario.id }
      expect(response).to redirect_to(formulario)
      expect(flash[:alert]).to match(/não foi possível excluir/i)
    end
  end



  describe 'GET #exportar_respostas_anonimas' do
    let(:perguntas) { [{ 'texto' => 'Pergunta 1' }, { 'texto' => 'Pergunta 2' }] }
    let(:template) { create(:template, formulario: { 'perguntas' => perguntas }) }
    let(:formulario) { create(:formulario, turma: turma, template: template) }
    let!(:resposta1) { create(:resposta, formulario: formulario, pergunta_index: 0, conteudo: 'R1') }
    let!(:resposta2) { create(:resposta, formulario: formulario, pergunta_index: 1, conteudo: 'R2') }

    it 'gera e envia o CSV com as respostas anonimas' do
      get :exportar_respostas_anonimas, params: { id: formulario.id }
      expect(response.header['Content-Type']).to include('text/csv')
      expect(response.body).to include('Pergunta 1')
      expect(response.body).to include('R1')
      expect(response.body).to include('R2')
    end
  end
end
