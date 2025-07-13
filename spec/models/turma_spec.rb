require 'rails_helper'

RSpec.describe Turma, type: :model do
    describe 'associations' do
        it { should belong_to(:docente).class_name('User').with_foreign_key(:id_docente) }
        it { should have_many(:turmas_alunos).dependent(:destroy) }
        it { should have_many(:alunos).through(:turmas_alunos).source(:aluno) }
        it { should have_many(:formularios).with_foreign_key(:id_turma).dependent(:destroy) }
    end

    describe '#periodo' do
        it 'extrai o período do class_data' do
            turma = Turma.new(class_data: 'semester 2024.1')
            expect(turma.periodo).to eq('2024.1')
        end

        it 'retorna "Não informado" se não houver período' do
            turma = Turma.new(class_data: nil)
            expect(turma.periodo).to eq('Não informado')
        end
    end

    describe '#horario' do
        it 'extrai o horário do class_data' do
            turma = Turma.new(class_data: 'time 10A')
            expect(turma.horario).to eq('10A')
        end

        it 'retorna "Não informado" se não houver horário' do
            turma = Turma.new(class_data: '')
            expect(turma.horario).to eq('Não informado')
        end
    end

    describe '#codigo_classe' do
        it 'extrai o código da classe do class_data' do
            turma = Turma.new(class_data: 'classCode ABC123')
            expect(turma.codigo_classe).to eq('ABC123')
        end

        it 'retorna "Não informado" se não houver código' do
            turma = Turma.new(class_data: nil)
            expect(turma.codigo_classe).to eq('Não informado')
        end
    end
end