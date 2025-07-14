# features/step_definitions/visualizacao_formularios_steps.rb

Given('existe um formulário publicado e ainda não respondido por mim') do
  turma_do_usuario = @current_user.turma
  FactoryBot.create(:formulario, turma: turma_do_usuario, status: 'publicado')
end

Given('não existem formulários pendentes para mim') do
  # Garante que não há formulários para a turma do usuário ou que ele já respondeu todos
end

When('visito a página {string}') do |pagina|
  visit pagina # Ex: visit '/formularios'
end

Then('devo ver o formulário na lista') do
  expect(page).to have_css('.lista-formularios .formulario-item') # Adapte o seletor
end

Then('não devo ver a mensagem {string}') do |mensagem|
  expect(page).not_to have_content(mensagem)
end
