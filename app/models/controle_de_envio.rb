##
# Modelo responsável por registrar os envios de formulários para alunos.
#
# Cada instância representa o vínculo entre um formulário e um aluno.
# Pode ser usada para controlar se um formulário foi enviado, visualizado ou respondido.
#
# ==== Associações
# * +aluno+ - Usuário com ocupação "dicente", representando o destinatário do formulário.
# * +formulario+ - Formulário associado ao envio.
class ControleDeEnvio < ApplicationRecord
  belongs_to :aluno, class_name: 'User', foreign_key: :aluno_id
  belongs_to :formulario
end
