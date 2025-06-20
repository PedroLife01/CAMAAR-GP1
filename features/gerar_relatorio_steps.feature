Feature: Gerar relatório do administrador
  Eu como Administrador
  Quero baixar um arquivo CSV contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas

  Background:
    Given estou autenticado como "admin"

  Scenario: Cenário Feliz – download de CSV com sucesso
    Given existe um formulário encerrado com respostas
    When seleciono o formulário "Avaliação Cálculo I"
    And clico em "Baixar CSV"
    Then devo receber o arquivo "avaliacao-calculo-I.csv"
    And devo ver a mensagem "Relatório gerado com sucesso"

  Scenario: Cenário Triste – formulário sem respostas
    Given existe um formulário sem respostas
    When seleciono o formulário "Pesquisa Sem Resposta"
    And clico em "Baixar CSV"
    Then devo ver a mensagem "Não há respostas para gerar relatório"
    And nenhum arquivo deve ser baixado
