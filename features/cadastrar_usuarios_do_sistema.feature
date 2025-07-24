Feature: Cadastrar usuários do sistema
  Eu como Administrador
  Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários
  A fim de que eles acessem o sistema CAMAAR

  Background:
    Given estou autenticado como "admin"

  Scenario: Cenário Feliz – usuário criado
    When preencho "Nome" com "Ana Souza"
    And seleciono "CIC" como "Curso"
    And preencho "Matrícula" com "200033522"
    And preencho "Usuario" com "200033522"
    And preencho "formacao" com "graduando"
    And preencho "E-mail" com "ana@example.com"
    And seleciono "Discente" em "Tipo de usuário"
    And clico em "Salvar"
    Then devo ver a mensagem "Usuário cadastrado com sucesso"
    And o usuário "ana@example.com" deve existir na base

  Scenario: Cenário Triste – e-mail já existente
    Given já existe um usuário com e-mail "ana@example.com"
    When preencho "Nome" com "Ana Souza"
    And seleciono "CIC" como "Curso"
    And preencho "Matrícula" com "200033522"
    And preencho "Usuario" com "200033522"
    And preencho "formacao" com "graduando"
    And preencho "E-mail" com "ana@example.com"
    And seleciono "Discente" em "Tipo de usuário"
    And clico em "Salvar"
    Then devo ver a mensagem "E-mail já está em uso"
    And o cadastro não deve ser realizado