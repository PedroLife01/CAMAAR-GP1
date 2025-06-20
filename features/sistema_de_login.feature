Feature: Sistema de Login
  Eu como Usuário do sistema
  Quero acessar o sistema utilizando e-mail ou matrícula e uma senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema

  Background:
    Given existe um usuário com e-mail "user@example.com" e senha "Senha@123"

  Scenario: Cenário Feliz – login bem-sucedido
    When preencho "E-mail" com "user@example.com"
    And preencho "Senha" com "Senha@123"
    And clico em "Entrar"
    Then devo ver a mensagem "Login efetuado com sucesso"
    And devo estar na página inicial

  Scenario: Cenário Triste – credenciais inválidas
    When preencho "E-mail" com "user@example.com"
    And preencho "Senha" com "errada"
    And clico em "Entrar"
    Then devo ver a mensagem "E-mail ou senha inválidos"
    And devo continuar na página de login