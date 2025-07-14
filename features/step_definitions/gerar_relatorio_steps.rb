# features/step_definitions/gerar_relatorio_steps.rb

Given('existe um formulário encerrado com respostas') do
  @formulario = FactoryBot.create(:formulario, :encerrado, :com_respostas)
end

Given('existe um formulário sem respostas') do
  @formulario = FactoryBot.create(:formulario, :encerrado)
end

When('seleciono o formulário {string}') do |formulario_nome|
  select formulario_nome, from: 'Formulário' # Adapte o seletor
end

Then('devo receber o arquivo {string}') do |nome_arquivo|
  # Testar downloads é complexo. Uma forma comum é verificar os headers da resposta.
  expect(page.response_headers['Content-Disposition']).to include("filename=\"#{nome_arquivo}\"")
end

Then('nenhum arquivo deve ser baixado') do
  # Verificamos que o header de download não foi enviado
  expect(page.response_headers['Content-Disposition']).to be_nil
end
