FactoryBot.define do
  factory :user do
    nome { Faker::Name.name }
    curso { Faker::Educator.course }
    matricula { Faker::Number.number(digits: 8) }
    usuario { Faker::Internet.username }
    formacao { Faker::Educator.degree }
    ocupacao { Faker::Job.title }
    email { Faker::Internet.email }
    password { "123456" }
  end
end
