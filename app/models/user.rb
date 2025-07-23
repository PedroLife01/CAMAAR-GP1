##
# Modelo que representa um usuário do sistema.
#
# Um usuário pode ter ocupação de +docente+ ou +dicente+, e suas permissões/associações mudam de acordo com isso.
# Utiliza o Devise para autenticação e gerenciamento de sessão.
#
# ==== Associações
# * +turmas+ - Turmas onde o usuário é docente (professor responsável).
# * +turmas_como_aluno+ - Turmas onde o usuário está matriculado como aluno.
# * +templates+ - Templates criados pelo usuário (quando docente).
# * +controle_de_envios+ - Registros de formulários enviados para o usuário (quando aluno).
#
# ==== Autenticação (Devise)
# Inclui os módulos: +database_authenticatable+, +registerable+, +recoverable+, +rememberable+ e +validatable+.
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
