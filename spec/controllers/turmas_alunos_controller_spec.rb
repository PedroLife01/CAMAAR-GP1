

require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'
require_relative '../support/shared_examples/atribui_shared_examples'


RSpec.describe TurmasAlunosController, type: :controller do
  let_it_be(:docente) { create(:user, ocupacao: 'docente') }
  let_it_be(:aluno)   { create(:user, ocupacao: 'dicente') }
  let_it_be(:turma)   { create(:turma, docente: docente) }

  before { sign_in docente }

  describe 'POST #create' do
    subject(:do_request) { post :create, params: { turma_id: turma.id, aluno_id: aluno.id } }

    context 'quando aluno não está vinculado' do
      it 'vincula aluno à turma e redireciona' do
        do_request
        expect(turma.alunos).to include(aluno)
        expect(response).to redirect_to(turma_path(turma, q: nil))
        expect(flash[:notice]).to match(/vinculado com sucesso/i)
      end
    end

    context 'quando aluno já está vinculado' do
      before { turma.alunos << aluno }
      it 'não vincula novamente e mostra alerta' do
        do_request
        expect(response).to redirect_to(turma_path(turma, q: nil))
        expect(flash[:alert]).to match(/já está vinculado/i)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      turma.alunos = []
      turma.alunos << aluno
    end
    let!(:turma_aluno) { turma.turmas_alunos.find_by(aluno_id: aluno.id) }
    it 'remove o vínculo do aluno com a turma' do
      delete :destroy, params: { turma_id: turma.id, id: turma_aluno.id }
      turma.reload
      turma.alunos.reload
      expect(turma.alunos.map(&:id).uniq).not_to include(aluno.id)
      expect(response).to have_http_status(:redirect)
    end
  end

  # Exemplo de uso dos shared_examples globais
  # include_examples 'atribui recurso', :turma, :show
  # include_examples 'atribui coleção', :turmas, :index
end
