# spec/factories/formularios.rb
FactoryBot.define do
  factory :formulario do
    titulo { "Titulo Teste" }
    descricao { "Descricao Teste" }
    data_abertura { Date.today }
    data_fechamento { Date.tomorrow }
    association :template
    association :turma
    association :docente, factory: :user
  end
end
