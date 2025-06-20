# features/step_definitions/criar_template_formulario_steps.rb

Given('estou autenticado como {string}') do |_papel|
  pending 'login admin'
end

When('clico em {string}') do |_botao|
  pending 'abrir formulário de novo template'
end

When('preencho {string} com {string}') do |_campo, _texto|
  pending 'preencher título'
end

When('adiciono a questão {string} do tipo {string}') do |_pergunta, _tipo|
  pending 'adicionar questão'
end

When('deixo o campo {string} em branco') do |_campo|
  pending 'titulo em branco'
end

Then('o template não deve ser criado') do
  pending 'verificar ausência de registro'
end

Then('devo ver a mensagem {string}') do |_mensagem|
  pending 'mensagem na UI'
end