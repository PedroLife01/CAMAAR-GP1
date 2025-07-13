# spec/models/user_spec.rb
require 'rails_helper'
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    specify { expect(User.reflect_on_association(:turmas).macro).to eq(:has_many) }
    specify { expect(User.reflect_on_association(:turmas).options[:foreign_key]).to eq(:id_docente) }
    specify { expect(User.reflect_on_association(:turmas).options[:dependent]).to eq(:nullify) }

    specify { expect(User.reflect_on_association(:turmas_alunos).macro).to eq(:has_many) }
    specify { expect(User.reflect_on_association(:turmas_alunos).options[:foreign_key]).to eq(:aluno_id) }
    specify { expect(User.reflect_on_association(:turmas_alunos).options[:dependent]).to eq(:destroy) }

    specify { expect(User.reflect_on_association(:turmas_como_aluno).macro).to eq(:has_many) }
    specify { expect(User.reflect_on_association(:turmas_como_aluno).options[:through]).to eq(:turmas_alunos) }
    specify { expect(User.reflect_on_association(:turmas_como_aluno).options[:source]).to eq(:turma) }

    specify { expect(User.reflect_on_association(:templates).macro).to eq(:has_many) }
    specify { expect(User.reflect_on_association(:templates).options[:foreign_key]).to eq(:id_user) }
  specify { expect(User.reflect_on_association(:templates).options[:dependent]).to eq(:destroy) }
  specify { expect(User.reflect_on_association(:controle_de_envios).macro).to eq(:has_many) }
  specify { expect(User.reflect_on_association(:controle_de_envios).options[:foreign_key]).to eq(:aluno_id) }
  specify { expect(User.reflect_on_association(:controle_de_envios).options[:dependent]).to eq(:destroy) }
end

  describe 'devise modules' do
    it 'includes database_authenticatable' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable' do
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe 'dependent: :nullify on turmas' do
    it 'nullifies id_docente on turmas when user is destroyed' do
      user = User.create!(email: 'docente@example.com', password: 'password')
      turma = Turma.create!(id_docente: user.id)
      user.destroy
      expect(turma.reload.id_docente).to be_nil
    end
  end

  describe 'dependent: :destroy on turmas_alunos' do
    it 'destroys turmas_alunos when user is destroyed' do
      user = User.create!(email: 'aluno@example.com', password: 'password')
      turma = Turma.create!(id_docente: user.id)
      turmas_aluno = TurmasAluno.create!(aluno_id: user.id, turma_id: turma.id)
      expect { user.destroy }.to change { TurmasAluno.count }.by(-1)
    end
  end

  describe 'dependent: :destroy on templates' do
    it 'destroys templates when user is destroyed' do
      user = User.create!(email: 'template@example.com', password: 'password')
      template = Template.create!(id_user: user.id, nome: 'Template 1')
      expect { user.destroy }.to change { Template.count }.by(-1)
    end
  end

  describe 'dependent: :destroy on controle_de_envios' do
    it 'destroys controle_de_envios when user is destroyed' do
      user = User.create!(email: 'aluno2@example.com', password: 'password')
      docente = User.create!(email: 'docente2@example.com', password: 'password')
      turma = Turma.create!(id_docente: docente.id)
      template = Template.create!(id_user: docente.id, nome: 'Template 2')
      formulario = Formulario.create!(template: template, turma: turma, docente: docente)
      envio = ControleDeEnvio.create!(aluno_id: user.id, formulario_id: formulario.id)
      expect { user.destroy }.to change { ControleDeEnvio.count }.by(-1)
    end
  end
end
