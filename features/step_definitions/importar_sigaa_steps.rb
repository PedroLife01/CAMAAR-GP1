# features/step_definitions/importar_sigaa_steps.rb

When('anexo o arquivo {string} ao campo {string}') do |nome_arquivo, campo|
  # O arquivo deve estar na pasta 'features/support/fixtures'
  attach_file(campo, Rails.root.join('features', 'support', 'fixtures', nome_arquivo))
end

Then('as turmas do arquivo devem existir na base') do
  # Exemplo: se o seu CSV tem turmas "Cálculo 1" e "Física 1"
  expect(Turma.exists?(nome: 'Cálculo 1')).to be true
  expect(Turma.exists?(nome: 'Física 1')).to be true
end

Then('nenhum registro deve ser criado') do
  # Exemplo para o modelo Turma
  expect { click_button 'Importar' }.not_to change(Turma, :count)
end
