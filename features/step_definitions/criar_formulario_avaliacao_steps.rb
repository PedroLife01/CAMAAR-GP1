# features/step_definitions/criar_formulario_avaliacao_steps.rb

Given('existe um template chamado {string}') do |template_nome|
  FactoryBot.create(:template, nome: template_nome)
end

Given('a turma {string} já possui um formulário ativo') do |turma_nome|
  turma = FactoryBot.create(:turma, nome: turma_nome)
  FactoryBot.create(:formulario, turma: turma, status: 'ativo')
end

When('seleciono o template {string}') do |template_nome|
  select template_nome, from: 'Template' 
end

When('seleciono as turmas {string} e {string}') do |turma1, turma2|
  check turma1
  check turma2
end

When('seleciono a turma {string}') do |turma_nome|
  select turma_nome, from: 'Turma' 
end

When('defino a data de encerramento para {string}') do |data|
  fill_in 'Data de Encerramento', with: data 
end

Then('o novo formulário não deve ser criado') do
  expect { click_button 'Salvar' }.not_to change(Formulario, :count)
end
