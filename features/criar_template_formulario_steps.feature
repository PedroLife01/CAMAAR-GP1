Feature: Criar template de formulário
  Eu como Administrador
  Quero criar um template de formulário contendo as questões do questionário
  A fim de gerar formulários de avaliação

  Background:
    Given estou autenticado como "admin"

  Scenario: Cenário Feliz – template salvo
    When clico em "Novo Template"
    And preencho "Título" com "Avaliação Docente Padrão"
    And adiciono a questão "Domínio do conteúdo" do tipo "Escala 1-5"
    And clico em "Salvar Template"
    Then devo ver a mensagem "Template criado com sucesso"

  Scenario: Cenário Triste – título em branco
    When clico em "Novo Template"
    And deixo o campo "Título" em branco
    And clico em "Salvar Template"
    Then devo ver a mensagem "Título não pode ficar em branco"
    And o template não deve ser criado