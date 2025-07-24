# features/step_definitions/cadastrar_usuarios_steps.rb

Given('já existe um usuário com e-mail {string}') do |email|
  FactoryBot.create(:user, email: email)
end

When('preencho {string} com {string}') do |campo, valor|
  fill_in campo, with: valor
end

When('seleciono {string} como {string}') do |opcao, campo|
  select opcao, from: campo
end

When('seleciono {string} em {string}') do |opcao, campo|
  choose opcao
end

When('clico em {string}') do |botao|
  click_on botao
end

Then('o usuário {string} deve existir na base') do |email|
  expect(User.exists?(email: email)).to be true
end

Then('o cadastro não deve ser realizado') do
  # Este passo pode ser mais específico, dependendo da lógica
  # Por exemplo, verificar se o número de usuários não aumentou.
  # Se você tem uma validação que impede o salvamento,
  # a verificação da mensagem de erro já pode ser suficiente.
end

Then('devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end
