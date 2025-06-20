Feature: Responder formulário
  Eu como Participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação

  Background:
    Given estou autenticado como "student"
    And existe um formulário publicado para minha turma

  Scenario: Cenário Feliz – resposta enviada
    When seleciono "5" na questão "Didática do docente"
    And clico em "Enviar"
    Then devo ver a mensagem "Obrigado pela sua participação"
    And minha resposta deve ser registrada

  Scenario: Cenário Triste – resposta invalida
    When não preencho a questão "Didática do docente"
    And clico em "Enviar"
    Then devo ver a mensagem "Você deve responder todas as perguntas do formulário"
    And não devo conseguir enviar minha resposta