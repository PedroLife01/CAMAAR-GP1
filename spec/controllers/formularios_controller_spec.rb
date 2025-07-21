
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
    it 'atribui @formulario, @turmas e @templates e renderiza new' do
      expect(assigns(:formulario)).to be_a(Formulario)
      expect(assigns(:turmas)).to include(turma)
      expect(assigns(:templates)).to include(template)
      expect(response).to render_template(:new)
    end
  end



  describe 'POST #create' do
    let(:valid_params) do
      {
        formulario: {
          titulo: 'Teste',
          descricao: 'Desc',
          data_abertura: Date.today,
          data_fechamento: Date.tomorrow,
          id_turma: turma.id,
          id_template: template.id
        }
      }
    end

    it 'cria formulário com sucesso e redireciona' do
      post :create, params: valid_params
      expect(response).to redirect_to(assigns(:formulario))
      expect(flash[:notice]).to match(/criado com sucesso/i)
    end

    it 'não cria formulário e renderiza new com erro' do
      allow_any_instance_of(Formulario).to receive(:save).and_return(false)
      post :create, params: valid_params
      expect(response).to render_template(:new)
      expect(flash[:alert]).to match(/Erro ao criar/i)
    end
  end



  describe 'GET #show' do
    it 'renderiza o show do formulário' do
      get :show, params: { id: formulario.id }
      expect(response).to render_template(:show)
    end
  end



  describe 'POST #enviar' do
    let(:aluno1) { create(:user, ocupacao: 'dicente') }
    let(:aluno2) { create(:user, ocupacao: 'dicente') }
    before { turma.alunos << [aluno1, aluno2] }

    it 'cria ControleDeEnvio para todos os alunos da turma e redireciona' do
      post :enviar, params: { id: formulario.id }
      expect(response).to redirect_to(formulario_path(formulario))
      expect(flash[:notice]).to match(/enviado com sucesso/i)
      expect(ControleDeEnvio.where(formulario_id: formulario.id, aluno_id: aluno1.id)).to exist
      expect(ControleDeEnvio.where(formulario_id: formulario.id, aluno_id: aluno2.id)).to exist
    end
  end



  describe 'filtros privados' do
    it 'set_formulario atribui o formulário correto' do
      controller.params[:id] = formulario.id
      controller.send(:set_formulario)
      expect(assigns(:formulario)).to eq(formulario)
    end

    it 'authorize_docente! permite docente e nega dicente' do
      expect(controller.send(:authorize_docente!)).to be_nil
      sign_out docente
      aluno = create(:user, ocupacao: 'dicente')
      sign_in aluno
      expect(controller).to receive(:redirect_to).with(root_path, alert: /Apenas docentes/i)
      controller.send(:authorize_docente!) rescue nil
    end
  end
end
