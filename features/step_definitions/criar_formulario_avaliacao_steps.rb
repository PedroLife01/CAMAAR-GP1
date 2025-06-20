# features/step_definitions/criar_formulario_avaliacao_steps.rb

Given('estou autenticado como {string}') do |_papel|
  pending 'implementar autenticação do usuário'
end

Given('existe um template chamado {string}') do |_template|
  pending 'implementar criação/verificação do template'
end

Given('a turma {string} já possui um formulário ativo') do |_turma|
  pending 'implementar verificação ou criação de formulário ativo para a turma'
end

When('seleciono o template {string}') do |_template|
  pending 'implementar seleção de template'
end

When('seleciono as turmas {string} e {string}') do |_turma1, _turma2|
  pending 'implementar seleção de múltiplas turmas'
end

When('seleciono a turma {string}') do |_turma|
  pending 'implementar seleção de uma turma'
end

When('defino a data de encerramento para {string}') do |_data_encerramento|
  pending 'implementar definição da data de encerramento'
end

When('clico em {string}') do |_botao|
  pending 'implementar clique em botão'
end

Then('devo ver a mensagem {string}') do |_mensagem|
  pending 'validar mensagem na tela'
end

Then('o novo formulário não deve ser criado') do
  pending 'garantir que o novo formulário não foi criado'
end
