# spec/factories/templates.rb
FactoryBot.define do
  factory :template do
    association :user
    nome { 'Template Teste' }
  end
end
