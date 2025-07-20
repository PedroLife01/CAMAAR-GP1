# spec/factories/turmas.rb
FactoryBot.define do
  factory :turma do
    name { 'Turma Teste' }
    class_data { 'semester 2023.2 time 10h classCode ABC123' }
    association :docente, factory: :user
  end
end
