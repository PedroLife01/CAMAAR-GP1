##
# Modelo que representa uma turma no sistema.
#
# Cada turma pertence a um docente e pode ter vários alunos vinculados.
# Também possui formulários associados e métodos auxiliares para extrair informações
# do campo +class_data+, que armazena metadados como semestre, horário e código da turma.
#
# ==== Associações
# * +docente+ - Usuário responsável pela turma (ocupação "docente").
# * +alunos+ - Usuários vinculados à turma como discentes.
# * +formularios+ - Formulários destinados à turma.
class Turma < ApplicationRecord
  # Docente responsável
  belongs_to :docente, class_name: 'User', foreign_key: :id_docente

  # Alunos vinculados
  has_many :turmas_alunos, dependent: :destroy
  has_many :alunos, through: :turmas_alunos, source: :aluno

  # Formularios associados
  has_many :formularios, foreign_key: :id_turma, dependent: :destroy

  ##
  # Extrai o semestre da turma a partir do campo +class_data+.
  #
  # ==== O que faz
  # Procura uma string como `"semester 2024.1"` dentro de +class_data+ e retorna o valor "2024.1".
  #
  # ==== Argumentos
  # * Nenhum.
  #
  # ==== Retorno
  # * String com o semestre (ex: "2024.1") ou "Não informado" se não encontrado.
  #
  # ==== Efeitos colaterais
  # * Nenhum.
  def periodo
    class_data.to_s[/semester\s+([\w.]+)/, 1] || "Não informado"
  end

  ##
  # Extrai o horário da turma a partir do campo +class_data+.
  #
  # ==== O que faz
  # Procura uma string como `"time T2"` dentro de +class_data+ e retorna o valor "T2".
  #
  # ==== Argumentos
  # * Nenhum.
  #
  # ==== Retorno
  # * String com o horário (ex: "T1", "M2") ou "Não informado" se não encontrado.
  #
  # ==== Efeitos colaterais
  # * Nenhum.
  def horario
    class_data.to_s[/time\s+([\w\d]+)/, 1] || "Não informado"
  end

  ##
  # Extrai o código da classe a partir do campo +class_data+.
  #
  # ==== O que faz
  # Procura uma string como `"classCode INF123"` dentro de +class_data+ e retorna o valor "INF123".
  #
  # ==== Argumentos
  # * Nenhum.
  #
  # ==== Retorno
  # * String com o código da classe (ex: "INF123") ou "Não informado" se não encontrado.
  #
  # ==== Efeitos colaterais
  # * Nenhum.
  def codigo_classe
    class_data.to_s[/classCode\s+(\w+)/, 1] || "Não informado"
  end
end
