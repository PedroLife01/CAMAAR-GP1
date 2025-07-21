
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
    before do
      Resposta.where(formulario: formulario, aluno: aluno).delete_all
    end

    context 'quando o aluno já respondeu o formulário' do
      let(:params) { respostas_params }
      before do
        Resposta.create!(formulario: formulario, aluno: aluno, pergunta_index: 0, conteudo: 'Já respondeu')
      end
      it 'redireciona com alerta de já respondido' do
        do_request
        expect(response).to redirect_to(formulario_path(formulario))
        expect(flash[:alert]).to match(/já respondeu/i)
      end
    end

    context 'quando há perguntas não respondidas' do
      let(:params) { respostas_params.merge('1' => { 'pergunta_index' => 1, 'conteudo' => '' }) }
      it 'redireciona com alerta de perguntas faltando' do
        do_request
        expect(response).to redirect_to(formulario_path(formulario))
        expect(flash[:alert]).to match(/responda todas as perguntas/i)
      end
    end

    context 'quando todas as respostas são válidas' do
      let(:params) { respostas_params }
      it 'cria respostas e redireciona com sucesso' do
        expect {
          post :create, params: { formulario_id: formulario.id, respostas: params }
        }.to change(Resposta, :count).by(2)
        expect(response).to redirect_to(formulario_path(formulario))
        expect(flash[:notice]).to match(/sucesso/i)
      end
    end

    context 'quando respostas_params está ausente' do
      it 'gera erro de parâmetros e não cria respostas' do
        expect {
          post :create, params: { formulario_id: formulario.id }
        }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'quando há perguntas extras não esperadas' do
      let(:params) do
        respostas_params.merge('2' => { 'pergunta_index' => 2, 'conteudo' => 'Extra' })
      end
      it 'cria respostas para todas as perguntas recebidas, inclusive extras' do
        expect {
          post :create, params: { formulario_id: formulario.id, respostas: params }
        }.to change(Resposta, :count).by(3)
        expect(Resposta.where(conteudo: 'Extra')).not_to be_empty
      end
    end
  end
end
