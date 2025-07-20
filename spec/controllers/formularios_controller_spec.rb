
require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'
require_relative '../support/shared_examples/atribui_shared_examples'

RSpec.describe FormulariosController, type: :controller do
  include TestProf::FactoryBot::Syntax

  let_it_be(:docente) { create(:user, ocupacao: 'docente') }
  let_it_be(:turma)   { create(:turma, id_docente: docente.id) }
  let_it_be(:template) { create(:template) }
  let_it_be(:formulario) { create(:formulario, docente: docente, turma: turma, template: template) }

  before { sign_in docente }



  describe 'GET #new' do
    before { get :new }
    include_examples 'atribui recurso', :formulario, :new
    it 'atribui turmas e templates' do
      expect(assigns(:turmas)).to include(turma)
      expect(assigns(:templates)).to include(template)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        titulo: 'Teste',
        descricao: 'Desc',
        data_abertura: Date.today,
        data_fechamento: Date.tomorrow,
        id_turma: turma.id,
        id_template: template.id
      }
    end

    subject(:do_request) { post :create, params: { formulario: params } }

    context 'com parâmetros válidos' do
      let(:params) { valid_params }
      it 'cria um novo formulário e redireciona' do
        expect { do_request }.to change(Formulario, :count).by(1)
        expect(response).to redirect_to(Formulario.last)
        expect(flash[:notice]).to match(/criado com sucesso/i)
      end
    end

    context 'com parâmetros inválidos' do
      let(:params) { valid_params.merge(titulo: nil) }
      it 'não cria, renderiza :new e atribui turmas/templates' do
        expect { do_request }.not_to change(Formulario, :count)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to match(/erro/i)
        expect(assigns(:turmas)).to include(turma)
        expect(assigns(:templates)).to include(template)
      end
    end
  end

  describe 'GET #show' do
    it 'atribui o formulário e renderiza show' do
      get :show, params: { id: formulario.id }
      expect(assigns(:formulario)).to eq(formulario)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #enviar' do
    let(:aluno) { create(:user, ocupacao: 'dicente') }
    before { formulario.turma.alunos << aluno }
    it 'cria ControleDeEnvio para cada aluno e redireciona' do
      expect {
        post :enviar, params: { id: formulario.id }
      }.to change(ControleDeEnvio, :count).by(1)
      expect(response).to redirect_to(formulario_path(formulario))
      expect(flash[:notice]).to match(/enviado com sucesso/i)
    end
  end

  describe 'filtros privados' do
    it 'redireciona se não for docente' do
      sign_out docente
      user = create(:user, ocupacao: 'dicente')
      sign_in user
      get :new
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match(/apenas docentes/i)
    end
  end
end
