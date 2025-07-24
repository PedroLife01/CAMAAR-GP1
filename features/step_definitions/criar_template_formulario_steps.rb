# features/step_definitions/criar_template_formulario_steps.rb

When('adiciono a questão {string} do tipo {string}') do |pergunta, tipo|
  click_on 'Adicionar Questão'
  within(all('.questao-fields').last) do
    fill_in 'Pergunta', with: pergunta
    select tipo, from: 'Tipo de Questão'
  end
end

When('deixo o campo {string} em branco') do |campo|
  fill_in campo, with: ''
end

Then('o template não deve ser criado') do
  expect { click_button 'Salvar' }.not_to change(Template, :count)
end
