
require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'
require_relative '../support/shared_examples/atribui_shared_examples'

RSpec.describe SigaaImportController, type: :controller do
  let_it_be(:docente) { create(:user, ocupacao: 'docente') }
  let_it_be(:admin)   { create(:user, ocupacao: 'admin') }
  let_it_be(:aluno)   { create(:user, ocupacao: 'dicente') }

  before { sign_in docente }


  describe 'GET #new' do
    before { get :new }
    it 'renderiza o template new' do
      expect(response).to render_template(:new)
      expect(response).to be_successful
    end
  end



  describe 'POST #create' do
    let(:classes_data) { [{ 'code' => 'T1', 'name' => 'Turma 1', 'class' => '2025.1' }] }
    let(:members_data) {
      [{
        'code' => 'T1',
        'docente' => {
          'email' => 'docente@exemplo.com', 'nome' => 'Docente', 'departamento' => 'Dep', 'usuario' => 'docente1', 'formacao' => 'Mestre'
        },
        'dicente' => [
          { 'email' => 'aluno@exemplo.com', 'nome' => 'Aluno', 'curso' => 'Curso', 'matricula' => '123', 'usuario' => 'aluno1', 'formacao' => 'Grad' }
        ]
      }]
    }
    let(:classes_file_path) { Rails.root.join('tmp', 'classes_test.json') }
    let(:members_file_path) { Rails.root.join('tmp', 'members_test.json') }
    let(:classes_file) do
      File.open(classes_file_path, 'w') { |f| f.write(classes_data.to_json) }
      fixture_file_upload(classes_file_path, 'application/json')
    end
    let(:members_file) do
      File.open(members_file_path, 'w') { |f| f.write(members_data.to_json) }
      fixture_file_upload(members_file_path, 'application/json')
    end

    subject(:do_request) { post :create, params: { classes_file: c_file, members_file: m_file } }

    context 'com arquivos válidos' do
      let(:c_file) { classes_file }
      let(:m_file) { members_file }
      it 'importa corretamente e redireciona com sucesso' do
        do_request
        expect(response).to redirect_to(sigaa_importar_path)
        expect(flash[:notice]).to match(/concluída com sucesso/i)
        expect(User.find_by(email: 'docente@exemplo.com')).not_to be_nil
        expect(User.find_by(email: 'aluno@exemplo.com')).not_to be_nil
        expect(Turma.find_by(code: 'T1')).not_to be_nil
      end
    end

    context 'sem arquivos' do
      let(:c_file) { nil }
      let(:m_file) { nil }
      it 'redireciona com erro se faltar arquivos' do
        do_request
        expect(response).to redirect_to(sigaa_importar_path)
        expect(flash[:alert]).to match(/precisa enviar os dois arquivos/i)
      end
    end

    context 'com erro de exceção' do
      let(:c_file) { classes_file }
      let(:m_file) { members_file }
      before { allow(JSON).to receive(:parse).and_raise(StandardError, 'erro json') }
      it 'redireciona com erro se houver exceção' do
        do_request
        expect(response).to redirect_to(sigaa_importar_path)
        expect(flash[:alert]).to match(/erro json/i)
      end
    end
  end



  describe 'filtro de autorização' do
    it 'permite acesso a docente e admin' do
      sign_out docente
      sign_in admin
      get :new
      expect(response).to be_successful
    end
    it 'nega acesso a dicente' do
      sign_out docente
      sign_in aluno
      get :new
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match(/não autorizado/i)
    end
  end
end
