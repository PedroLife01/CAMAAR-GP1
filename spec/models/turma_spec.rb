require 'rails_helper'

RSpec.describe Turma, type: :model do
  describe 'associações' do
    it { should belong_to(:docente).class_name('User').with_foreign_key(:id_docente) }
    it { should have_many(:turmas_alunos).dependent(:destroy) }
    it { should have_many(:alunos).through(:turmas_alunos).source(:aluno) }
    it { should have_many(:formularios).with_foreign_key(:id_turma).dependent(:destroy) }
  end

  describe 'métodos de instância' do
    let(:turma) { build(:turma, class_data: 'semester 2023.2 time 10h classCode ABC123') }

    it 'retorna o período corretamente' do
      expect(turma.periodo).to eq('2023.2')
    end

    it 'retorna o horário corretamente' do
      expect(turma.horario).to eq('10h')
    end

    it 'retorna o código da classe corretamente' do
      expect(turma.codigo_classe).to eq('ABC123')
    end

    it 'retorna "Não informado" se não houver dados' do
      turma.class_data = nil
      expect(turma.periodo).to eq('Não informado')
      expect(turma.horario).to eq('Não informado')
      expect(turma.codigo_classe).to eq('Não informado')
    end
  end
end
