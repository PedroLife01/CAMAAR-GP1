Feature: Visualização de resultados dos formulários  
  Eu como Administrador
  Quero visualizar os formulários criados
  A fim de gerar relatórios a partir das respostas

  Background:
    Given estou autenticado como "admin"

  Scenario: Cenário Feliz – resultados exibidos
    Given existe um formulário encerrado com respostas
    When visito a página "Resultados" para esse formulário
    Then devo ver uma lista com as respostas
    And devo ver o texto "Total de respostas:"

  Scenario: Cenário Triste – formulário sem respostas
    Given existe um formulário encerrado sem respostas
    When visito a página "Resultados" para esse formulário
    Then devo ver a mensagem "Ainda não há respostas para este formulário"
    And não devo ver gráficos