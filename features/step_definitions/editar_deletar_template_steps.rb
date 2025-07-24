# features/step_definitions/editar_deletar_template_steps.rb

When('clico em {string} para {string}') do |acao, titulo|
  # Encontra a linha da tabela que contém o título e clica no botão de ação
  find('tr', text: titulo).click_on(acao)
end

Then('devo ver {string} na lista de templates') do |titulo|
  expect(page).to have_css('table tr', text: titulo)
end

Then('o template {string} deve continuar na lista') do |titulo|
  expect(page).to have_css('table tr', text: titulo)
end
