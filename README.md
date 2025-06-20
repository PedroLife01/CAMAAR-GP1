# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

## 🚀 Tecnologias Utilizadas

- Ruby on Rails
- PostgreSQL
- Cucumber (BDD)
- FactoryBot (fábricas de teste)
- Capybara (testes de interface)
- Selenium WebDriver (opcional)
- Devise (autenticação)
- Rolify (gestão de papéis - roles)

---

## 📦 Requisitos

- Ruby >= 3.0
- Rails >= 7
- PostgreSQL
- NodeJS + Yarn
- Bundler (`gem install bundler`)

---

## 🛠️ Como rodar o projeto localmente

```bash
# Instale as gems
bundle install

# Instale pacotes JS (se usar webpack ou similar)
yarn install

# Configure o banco de dados
rails db:create db:migrate db:seed

# Rode o servidor
rails server

## Integrantes

Lucas Fernandes da Silveira Campos - 180022563
Marcelo Piano Patusco Santiago - 200049496
OMARQUES SANTOS GONCALVES JUNIOR - 190018577
Pedro Victor Roriz Sardenberg - 202107369

## Sprint 1
 - Scrum Master: Pedro Victor
 - Product Owner: Marcelo Piano

### Funcionalidades desenvolvidas
 - Criação do repositorio
 - BDD das features do repositorio principal
 - Documentação do BDD

### Responsavel por cada funcionalidade

 - Responsavel por realizar cada BDD

| Issue | Título                                                      | Responsável |
|-------|-------------------------------------------------------------|-------------|
| #098  | Importar dados do SIGAA                                     | TODOS       |
| #099  | Responder formulário                                        | MARCELO     |
| #100  | Cadastrar usuários do sistema                               | LUCAS       |
| #101  | Gerar relatório do administrador                            | OMARQUES    |
| #102  | Criar template de formulário                                | RORIZ       |
| #103  | Criar formulário de avaliação                               | MARCELO     |
| #104  | Sistema de Login                                            | LUCAS       |
| #105  | Sistema de definição de senha                               | OMARQUES    |
| #106 *| Sistema de gerenciamento por departamento                   | A           |
| #107 *| Redefinição de senha                                        | A           |
| #108  | Atualizar base de dados com os dados do SIGAA               | RORIZ       |
| #109  | Visualização de formulários para responder                  | MARCELO     |
| #110  | Visualização de resultados dos formulários                  | LUCAS       |
| #111  | Visualização dos templates criados                          | OMARQUES    |
| #112  | Edição e deleção de templates                               | RORIZ       |
| #113 *| Criação de formulário para docentes ou dicentes             | A           |


### Política de Branching

Utilizamos o modelo **GitHub Flow**:
- Todo desenvolvimento parte da branch `main`.
- Criar uma nova branch a partir de `main` para cada feature ou correção:
  - Padrão: `feat/nome-descritivo` ou `bugfix/descricao`
- Abrir Pull Request para `main` quando a feature estiver pronta.
- É obrigatório passar nos testes automáticos e ter aprovação de pelo menos 1 revisor antes do merge.
