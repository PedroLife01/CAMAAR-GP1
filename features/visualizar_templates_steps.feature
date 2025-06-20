Feature: Visualização dos templates criados
  Eu como Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template

  Background:
    Given estou autenticado como "admin"

  Scenario: Cenário Feliz – lista com 2 templates
    Given possuo 2 templates cadastrados
    When visito a página "Templates"
    Then devo ver 2 linhas na tabela de templates

  Scenario: Cenário Triste – nenhum template cadastrado
    Given não possuo templates cadastrados
    When visito a página "Templates"
    Then devo ver a mensagem "Nenhum template encontrado"