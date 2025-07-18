Feature: Sistema de definição de senha 
  Eu como Usuário
  Quero definir uma senha para o meu usuário a partir do e-mail de convite
  A fim de acessar o sistema

  Background:
    Given possuo um token de convite válido

  Scenario: Cenário Feliz – senha definida
    When visito o link de convite com meu token
    And preencho "Senha" com "NovaSenha@123"
    And preencho "Confirmação de Senha" com "NovaSenha@123"
    And clico em "Salvar"
    Then devo ver a mensagem "Senha criada com sucesso"
    And devo poder fazer login com "NovaSenha@123"

  Scenario: Cenário Triste – senhas não coincidem
    When visito o link de convite com meu token
    And preencho "Senha" com "NovaSenha@123"
    And preencho "Confirmação de Senha" com "OutraSenha"
    And clico em "Salvar"
    Then devo ver a mensagem "Confirmação não corresponde à senha"
    And a senha não deve ser alterada