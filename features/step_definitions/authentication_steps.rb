Given('estou autenticado como {string}') do |papel|
  # Cria um usuário com o papel desejado (admin, coordenador, etc.)
  @usuario_logado = FactoryBot.create(
    :user,
    role: admin,
    email: "#{papel}@exemplo.com",
    password: '123456'
  )

  # Acessa a página de login
  visit '/login' # ajuste essa rota conforme sua app

  # Preenche o formulário de login
  fill_in 'Email', with: @usuario_logado.email
  fill_in 'Senha', with: '123456'

  # Clica para entrar
  click_button 'Entrar' # ou o texto real do botão

  # Verifica se login foi bem-sucedido
  expect(page).to have_content('Bem-vindo') # ou qualquer coisa visível na tela pós-login
end
