# spec/factories/respostas.rb
FactoryBot.define do
  factory :resposta do
    association :formulario
    association :aluno, factory: :user
    pergunta_index { 1 }
    conteudo { 'Resposta de teste' }
  end
end
