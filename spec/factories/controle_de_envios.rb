# spec/factories/controle_de_envios.rb
FactoryBot.define do
  factory :controle_de_envio do
    association :aluno, factory: :user
    association :formulario
  end
end
