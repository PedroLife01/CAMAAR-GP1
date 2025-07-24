# features/step_definitions/visualizar_resultados_steps.rb

Given('existe um formulário encerrado sem respostas') do
  @formulario = FactoryBot.create(:formulario, :encerrado)
end

When('visito a página {string} para esse formulário') do |pagina|
  # Exemplo: /formularios/1/resultados
  visit "/formularios/#{@formulario.id}/#{pagina.downcase}"
end

Then('devo ver uma lista com as respostas') do
  # Exemplo: verifica se existe uma tabela ou lista de respostas
  expect(page).to have_css('.lista-respostas') # Adapte o seletor
end

Then('não devo ver gráficos') do
  expect(page).not_to have_css('.grafico-resultados') # Adapte o seletor
end

Then('devo ver o texto {string}') do |texto|
  expect(page).to have_text(texto)
end
