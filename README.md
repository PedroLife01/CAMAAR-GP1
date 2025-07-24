# CAMAAR

Sistema para avaliação de atividades acadêmicas remotas do CIC.

---

## 🚀 Tecnologias Utilizadas

- **Ruby on Rails** (framework principal)
- **PostgreSQL** (banco de dados)
- **Cucumber** (BDD)
- **Capybara** (testes de interface)
- **Selenium WebDriver** (opcional para testes de navegador)
- **Devise** (autenticação de usuários)
- **Rolify** (gestão de papéis - roles)
- **RailsAdmin** (dashboard administrativo)
- **RDoc** (documentação do código)
- **Rspec** (cobertura de testes)
- **RubyCritic** (análise de qualidade de código)

---

## 📦 Requisitos

- **Ruby >= 3.0**
- **Rails >= 7**
- **PostgreSQL**
- **NodeJS + Yarn**
- **Bundler** (`gem install bundler`)

---

## 🛠️ Como rodar o projeto localmente

```bash
# Instale as gems
bundle install

# Instale pacotes JS (se usar webpack ou similar)
yarn install

# Crie um arquivo .env na raiz com suas credenciais do PostgreSQL:
DB_USERNAME=seu_usuario
DB_PASSWORD=sua_senha

# Configure o banco de dados
rails db:create db:migrate db:seed

# Lembre de realizar a documentação e os teste com o servidor rodando e tudo configurado.

# Para gerar a documentação dos controllers
rdoc app/controllers

# Para gerar a documentação dos models
rdoc app/models

# Para gerar a documentação de ambos
rdoc app/controllers app/models

# Para rodar os testes
rspec

# Rode o servidor
rails server
# ou
./bin/dev
````
---

## **Acesso e Usuários**

* Após rodar o `db:seed`, são criados usuários padrões (1 professor, 1 turma e vários alunos).
* **Senha padrão**: `123456`
* O conteúdo de emails (recuperação de senha, confirmação) é exibido no **terminal** durante o desenvolvimento (não há SMTP configurado).
* O administrador tem acesso ao painel administrativo em **`/admin`** (interface gerada pela gem `RailsAdmin`).

---

## **Integrantes**

* Lucas Fernandes da Silveira Campos - 180022563
* Marcelo Piano Patusco Santiago - 200049496
* Omarques Santos Goncalves Junior - 190018577
* Pedro Victor Roriz Sardenberg - 202107369

---

## **Sprint 1**

**Scrum Master**: Pedro Victor
**Product Owner**: Marcelo Piano

### **Funcionalidades desenvolvidas**

* Criação do repositório.
* BDD das features do sistema.
* Documentação do BDD.

### **Responsável por cada funcionalidade**

* Cada integrante implementou o BDD relacionado às suas tarefas.

| Issue | Título                                        | Responsável |
| ----- | --------------------------------------------- | ----------- |
| #098  | Importar dados do SIGAA                       | TODOS       |
| #099  | Responder formulário                          | MARCELO     |
| #100  | Cadastrar usuários do sistema                 | LUCAS       |
| #101  | Gerar relatório do administrador              | OMARQUES    |
| #102  | Criar template de formulário                  | RORIZ       |
| #103  | Criar formulário de avaliação                 | MARCELO     |
| #104  | Sistema de Login                              | LUCAS       |
| #105  | Sistema de definição de senha                 | OMARQUES    |
| #106  | Sistema de gerenciamento por departamento     | RORIZ       |
| #107  | Redefinição de senha                          | RORIZ       |
| #108  | Atualizar base de dados com os dados do SIGAA | RORIZ       |
| #109  | Visualização de formulários para responder    | MARCELO     |
| #110  | Visualização de resultados dos formulários    | LUCAS       |
| #111  | Visualização dos templates criados            | OMARQUES    |
| #112  | Edição e deleção de templates                 | RORIZ       |

---

## **Sprint 2**

**Scrum Master**: Lucas Fernandes
**Product Owner**: Pedro Victor

### **Entregas da Sprint**

* Implementação das features definidas na Sprint 1, seguindo os cenários de BDD.
* Testes com RSpec, Capybara e Cucumber implementados e validados.
* Estrutura de **steps** do Cucumber revisada.
* Kanban do projeto atualizado ([link do Kanban](https://github.com/users/PedroLife01/projects/1/views/1)).

### **Pendências**

* A wiki com a documentação das features foi adiada para a Sprint 3 junto da refatoração.

---

## **Sprint 3**

**Scrum Master**: Omarques
**Product Owner**: Marcelo Piano

### **Foco da Sprint**

* Refatoração do código e documentação com RDoc.
* Uso da ferramenta **RubyCritic** para manter **ABC Score < 20** por método.
* Cobertura de testes com ** > 90%**.
* Garantia de **Happy Path** e **Sad Path** nos testes RSpec e Cucumber.
* Documentação detalhada com RDoc para **controllers, models e métodos**.

### **Resultados**

* Código refatorado para manter qualidade (métodos simplificados).
* Testes automatizados com cobertura superior a 90%.
* Adicionadas validações, mensagens de erro e fluxos alternativos (Sad Paths).
* Documentação RDoc completa.

---

## **Modelo do Banco de Dados**

<img width="2620" height="2056" alt="drawSQL-CAAMAR" src="https://github.com/user-attachments/assets/d7da29f6-6b7f-41e1-b504-d172683aab0c" />

---

## **Política de Branching**

Utilizamos o modelo **GitHub Flow**:

* Branch principal: `main`.
* Cada feature ou correção: `feat/nome-descritivo` ou `bugfix/descricao`.
* Pull Requests obrigatórios com **review** e testes passando.

---

## **Tarefas por integrante**

**Sprint 2**

* **Pedro Victor Roriz**: Implementação de templates, edição/deleção de templates,Dashboard admin (RailsAdmin) e paginas de aluno e professor.
* **Lucas Fernandes**: Cadastro de usuários, login e autenticação, testes com Devise.
* **Marcelo Piano**: Responder formulários, criação de formulários, testes de interface.
* **Omarques Santos**:  integração com RSpec, relatórios e roles.

**Sprint 3**

* **Pedro Victor Roriz**: Refatoração de controllers, otimização ABC Score e melhorias no admin.
* **Lucas Fernandes**: Cobertura de Sad Paths nos testes Cucumber/RSpec.
* **Marcelo Piano**: Documentação RDoc de controllers/models e cobertura de testes.
* **Omarques Santos**: Configuração Rspec, RubyCritic e otimização ABC Score.

---
