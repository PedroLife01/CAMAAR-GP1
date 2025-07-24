##
# Modelo responsável por registrar os envios de formulários para alunos.
#
# Cada instância representa o vínculo entre um formulário e um aluno, permitindo:
# - Saber se o formulário foi enviado para determinado aluno;
# - Controlar o status de visualização ou resposta;
# - Evitar envios duplicados com uso de validações ou verificações associadas.
#
# ==== Atributos esperados
# * +aluno_id+ [Integer] - ID do usuário com ocupação "dicente".
# * +formulario_id+ [Integer] - ID do formulário enviado.
# * +is_envio+ [Boolean] - (opcional) se o formulário foi efetivamente enviado.
#
# ==== Associações
# * +aluno+ - Referência ao model +User+ com papel de aluno.
# * +formulario+ - Referência ao model +Formulario+ vinculado.
#
# ==== Exemplo de uso
#   ControleDeEnvio.create!(
#     aluno_id: aluno.id,
#     formulario_id: formulario.id,
#     is_envio: true
#   )
#
class ControleDeEnvio < ApplicationRecord
  belongs_to :aluno, class_name: 'User', foreign_key: :aluno_id
  belongs_to :formulario
end
