##
# Modelo que representa um usuário do sistema.
#
# Um usuário pode ter ocupação de +docente+ ou +dicente+, e suas permissões e associações variam conforme essa ocupação.
# Utiliza o Devise para autenticação e gerenciamento de sessão.
#
# ==== Associações
# * +turmas+ - Turmas onde o usuário atua como docente (campo `id_docente` nas turmas).
# * +turmas_como_aluno+ - Turmas nas quais o usuário está vinculado como aluno (relacionamento N:N via `turmas_alunos`).
# * +templates+ - Templates de formulário criados pelo usuário (quando docente).
# * +controle_de_envios+ - Registros de formulários enviados para o usuário (quando aluno).
#
# ==== Autenticação (Devise)
# Inclui os módulos:
# - +:database_authenticatable+
# - +:registerable+
# - +:recoverable+
# - +:rememberable+
# - +:validatable+
#
# ==== Observações
# * O campo +ocupacao+ define o papel do usuário: "docente" ou "dicente".
# * A senha padrão pode ser configurada no momento da importação (ver `SigaaImportController`).
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Um usuário pode ser docente (dono de turma)
  has_many :turmas, foreign_key: :id_docente, dependent: :nullify

  # Um usuário pode ser aluno em várias turmas
  has_many :turmas_alunos, foreign_key: :aluno_id, dependent: :destroy
  has_many :turmas_como_aluno, through: :turmas_alunos, source: :turma

  # Um usuário pode criar vários templates
  has_many :templates, foreign_key: :id_user, dependent: :destroy

  # Um usuário pode ter controle de envios (aluno)
  has_many :controle_de_envios, foreign_key: :aluno_id, dependent: :destroy
end
