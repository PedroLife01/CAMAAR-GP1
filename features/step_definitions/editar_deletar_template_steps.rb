# features/step_definitions/editar_deletar_template_steps.rb

Given('estou autenticado como {string}') do |_papel|
  pending 'login admin'
end

Given('existe um template chamado {string}') do |_titulo|
  pending 'criar template'
end

When('clico em {string} para {string}') do |_acao, _titulo|
  pending 'clicar editar/excluir'
end

When('preencho {string} com {string}') do |_campo, _valor|
  pending 'alterar título'
end

Then('devo ver {string} na lista de templates') do |_titulo|
  pending 'validar título atualizado'
end

Then('o template {string} deve continuar na lista') do |_titulo|
  pending 'template não removido'
end

Then('devo ver a mensagem {string}') do |_mensagem|
  pending 'mensagem na UI'
end