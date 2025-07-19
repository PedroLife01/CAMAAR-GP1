FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    
    trait :docente do
      sequence(:email) { |n| "docente#{n}@example.com" }
    end
    
    trait :aluno do
      sequence(:email) { |n| "aluno#{n}@example.com" }
    end
  end
  
  factory :turma do
    association :docente, factory: [:user, :docente], foreign_key: :id_docente
  end
  
  factory :template do
    association :user, foreign_key: :id_user
    sequence(:nome) { |n| "Template #{n}" }
  end
  
  factory :formulario do
    association :template
    association :turma
    association :docente, factory: :user
  end
  
  factory :controle_de_envio do
    association :aluno, factory: [:user, :aluno]
    association :formulario
  end
  
  factory :turmas_aluno do
    association :aluno, factory: [:user, :aluno]
    association :turma
  end
end