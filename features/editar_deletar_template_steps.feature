Feature: Edição e deleção de templates
  Eu como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Background:
    Given estou autenticado como "admin"
    And existe um template chamado "Template Antigo"

  Scenario: Cenário Feliz – edição de título com sucesso
    When clico em "Editar" para "Template Antigo"
    And preencho "Título" com "Template Atualizado"
    And clico em "Salvar"
    Then devo ver a mensagem "Template atualizado com sucesso"
    And devo ver "Template Atualizado" na lista de templates

  Scenario: Cenário Triste – tentativa de deleção de template ligado a formulário
    When clico em "Excluir" para "Template Antigo"
    Then devo ver a mensagem "Não é possível excluir: template já utilizado em formulário"
    And o template "Template Antigo" deve continuar na lista