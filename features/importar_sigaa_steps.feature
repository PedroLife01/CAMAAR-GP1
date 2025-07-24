Feature: Importar dados do SIGAA
  Eu como Administrador
  Quero importar dados de turmas, matérias e participantes do SIGAA
  A fim de alimentar a base de dados do sistema

  Background:
    Given estou autenticado como "admin"

  Scenario: Cenário Feliz – importação bem-sucedida
    When clico em "Importar Dados"
    And anexo o arquivo "spec/fixtures/sigaa_valido.json" ao campo "Arquivo"
    Then devo ver a mensagem "Dados importados com sucesso"
    And as turmas do arquivo devem existir na base

  Scenario: Cenário Triste – arquivo em formato inválido
    When anexo o arquivo "spec/fixtures/sigaa_invalido.csv" ao campo "Arquivo"
    And clico em "Importar Dados"
    Then devo ver a mensagem "Formato de arquivo não suportado"
    And nenhum registro deve ser criado