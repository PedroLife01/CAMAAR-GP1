# spec/factories/turmas_alunos.rb
FactoryBot.define do
  factory :turmas_aluno do
    association :turma
    association :aluno, factory: :user
  end
end
