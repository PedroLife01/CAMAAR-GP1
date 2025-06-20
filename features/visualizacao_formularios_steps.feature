Feature: Visualização de formulários para responder
  Eu como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de poder escolher qual irei responder

  Background:
    Given estou autenticado como "dicente"

  Scenario: Cenário Feliz – lista com formulário pendente
    Given existe um formulário publicado e ainda não respondido por mim
    When visito a página "Formulários disponíveis"
    Then devo ver o formulário na lista
    And não devo ver a mensagem "Nenhum formulário pendente"

  Scenario: Cenário Triste – não há formulários pendentes
    Given não existem formulários pendentes para mim
    When visito a página "Formulários disponíveis"
    Then devo ver a mensagem "Nenhum formulário pendente"
