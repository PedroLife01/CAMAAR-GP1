Feature: Atualizar base de dados com os dados do SIGAA
  Eu como Administrador
  Quero atualizar a base de dados existente com os dados atuais do SIGAA
  A fim de corrigir a base de dados do sistema

  Background:
    Given estou autenticado como "admin"

  Scenario: Cenário Feliz – sincronização disparada
    When clico em "Sincronizar agora"
    Then devo ver a mensagem "Sincronização iniciada"
    And o job "SyncSigaaJob" deve ter sido enfileirado

  Scenario: Cenário Triste – SIGAA indisponível
    Given o serviço do SIGAA está fora do ar
    When clico em "Sincronizar agora"
    Then devo ver a mensagem "Falha ao conectar ao SIGAA"
    And nenhum job deve ser enfileirado