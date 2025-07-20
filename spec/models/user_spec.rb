require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associações' do
    it 'tem muitas turmas como docente' do
      expect(subject).to have_many(:turmas).with_foreign_key(:id_docente).dependent(:nullify)
    end

    it 'tem muitas turmas_alunos como aluno' do
      expect(subject).to have_many(:turmas_alunos).with_foreign_key(:aluno_id).dependent(:destroy)
    end

    it 'tem muitas turmas como aluno (turmas_como_aluno)' do
      expect(subject).to have_many(:turmas_como_aluno).through(:turmas_alunos).source(:turma)
    end

    it 'tem muitos templates' do
      expect(subject).to have_many(:templates).with_foreign_key(:id_user).dependent(:destroy)
    end

    it 'tem muitos controles de envio' do
      expect(subject).to have_many(:controle_de_envios).with_foreign_key(:aluno_id).dependent(:destroy)
    end
  end

  context 'devise' do
    it 'responde a valid_password?' do
      expect(subject).to respond_to(:valid_password?)
    end
    it 'responde a email' do
      expect(subject).to respond_to(:email)
    end
  end
end
