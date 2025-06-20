# features/step_definitions/responder_formulario_steps.rb

Given('estou autenticado como {string}') do |_papel|
  pending 'implementar autenticação do usuário'
end

Given('existe um formulário publicado para minha turma') do
  pending 'implementar criação/publicação de formulário para a turma'
end

When('seleciono {string} na questão {string}') do |_resposta, _questao|
  pending 'implementar seleção de resposta'
end

When('não preencho a questão {string}') do |_questao|
  pending 'implementar ausência de resposta'
end

When('clico em {string}') do |_botao|
  pending 'implementar clique em botão'
end

Then('devo ver a mensagem {string}') do |_mensagem|
  pending 'validar mensagem na tela'
end

Then('minha resposta deve ser registrada') do
  pending 'garantir que a resposta foi salva'
end

Then('não devo conseguir enviar minha resposta') do
  pending 'garantir que a resposta não foi salva'
end
