# features/step_definitions/atualizar_sigaa_steps.rb

Given('estou autenticado como {string}') do |_papel|
  pending 'login admin'
end

Given('o serviço do SIGAA está fora do ar') do
  pending 'mock de indisponibilidade'
end

When('clico em {string}') do |_botao|
  pending 'clicar no botão de sincronização'
end

Then('o job {string} deve ter sido enfileirado') do |_job|
  pending 'verificar job enfileirado'
end

Then('nenhum job deve ser enfileirado') do
  pending 'verificar fila vazia'
end

Then('devo ver a mensagem {string}') do |_mensagem|
  pending 'mensagem na tela'
end