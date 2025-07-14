# features/step_definitions/responder_formulario_steps.rb

Given('existe um formulário publicado para minha turma') do
  turma_do_usuario = @current_user.turma # Supondo que o usuário tenha uma turma
  FactoryBot.create(:formulario, turma: turma_do_usuario, status: 'publicado')
end

When('seleciono {string} na questão {string}') do |resposta, questao|
  # Encontra a div ou fieldset da questão e seleciona a opção dentro dela
  within_fieldset(questao) do
    choose(resposta)
  end
end

When('não preencho a questão {string}') do |questao|
  # Não faz nada, garantindo que o campo da questão fique em branco.
  # O teste verificará a validação do backend/frontend.
end

Then('minha resposta deve ser registrada') do
  # Exemplo: verifica se uma nova resposta foi criada para o usuário atual
  expect(Resposta.where(user: @current_user)).to exist
end

Then('não devo conseguir enviar minha resposta') do
  # Exemplo: verifica que nenhuma resposta foi criada
  expect(Resposta.where(user: @current_user)).not_to exist
end
