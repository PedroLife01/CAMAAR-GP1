# features/step_definitions/cadastrar_usuarios_steps.rb

Given('estou autenticado como {string}') do |_papel|
  pending 'login admin pendente'
end

Given('já existe um usuário com e-mail {string}') do |_email|
  pending 'criar usuário duplicado'
end

When('preencho {string} com {string}') do |_campo, _valor|
  pending 'preencher campo'
end

When('seleciono {string} como {string}') do |_opcao, _campo|
  pending 'selecionar opção em select'
end

When('seleciono {string} em {string}') do |_opcao, _campo|
  pending 'selecionar tipo usuário'
end

When('clico em {string}') do |_botao|
  pending 'ação de clique'
end

Then('o usuário {string} deve existir na base') do |_email|
  pending 'verificar usuário criado'
end

Then('o cadastro não deve ser realizado') do
  pending 'garantir que não houve criação'
end

Then('devo ver a mensagem {string}') do |_mensagem|
  pending 'exibir mensagem correta'
end