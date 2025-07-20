
require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'
require_relative '../support/shared_examples/atribui_shared_examples'

RSpec.describe RespostasController, type: :controller do
  let_it_be(:aluno)    { create(:user, ocupacao: 'dicente') }
  let_it_be(:docente)  { create(:user, ocupacao: 'docente') }
  let_it_be(:template) { create(:template) }
  let_it_be(:turma)    { create(:turma, id_docente: docente.id) }
  let_it_be(:formulario) { create(:formulario, docente: docente, turma: turma, template: template) }
  let(:perguntas) { [{ 'texto' => 'Pergunta 1' }, { 'texto' => 'Pergunta 2' }] }

  before do
    sign_in aluno
    allow_any_instance_of(Template).to receive(:formulario).and_return({ 'perguntas' => perguntas })
  end

  let(:respostas_params) do
    {
      '0' => { 'pergunta_index' => 0, 'conteudo' => 'Resposta 1' },
      '1' => { 'pergunta_index' => 1, 'conteudo' => 'Resposta 2' }
    }
  end

  subject(:do_request) { post :create, params: { formulario_id: formulario.id, respostas: params } }

  describe 'POST #create' do
    context 'com respostas válidas' do
      let(:params) { respostas_params }
      it 'cria respostas e redireciona com sucesso' do
        expect { do_request }.to change(Resposta, :count).by(2)
        expect(response).to redirect_to(formulario_path(formulario))
        expect(flash[:notice]).to match(/sucesso/i)
      end
    end

    context 'quando já respondeu' do
      let(:params) { respostas_params }
      it 'não permite responder o mesmo formulário duas vezes' do
        do_request # primeira resposta
        do_request # tentativa duplicada
        expect(response).to redirect_to(formulario_path(formulario))
        expect(flash[:alert]).to match(/já respondeu/i)
      end
    end

    context 'com respostas incompletas' do
      let(:params) { respostas_params.merge('1' => { 'pergunta_index' => 1, 'conteudo' => '' }) }
      before do
        # Remove qualquer resposta prévia do aluno para o formulário
        Resposta.where(formulario: formulario, aluno: aluno).delete_all
      end
      it 'não permite enviar se faltar resposta' do
        do_request
        expect(response).to redirect_to(formulario_path(formulario))
        expect(flash[:alert]).to match(/responda todas as perguntas antes de enviar o formulário/i)
      end
    end
  end
end
