##
# Controller responsável por processar o envio de respostas a um formulário.
#
# Garante que o usuário esteja autenticado, evita múltiplas submissões
# e valida se todas as perguntas foram respondidas.
#
# Este controller está ligado diretamente à submissão de formulários respondidos
# por discentes na aplicação.
class RespostasController < ApplicationController
  before_action :authenticate_user!

  ##
  # Cria as respostas de um formulário submetidas pelo usuário atual.
  #
  # ==== Parâmetros
  # * +params[:formulario_id]+ - ID do formulário sendo respondido.
  # * +params[:respostas]+ - Hash contendo as respostas fornecidas, com os índices das perguntas como chaves.
  #
  # ==== Regras e validações
  # - Impede que um mesmo usuário responda o mesmo formulário mais de uma vez.
  # - Verifica se todas as perguntas do template foram devidamente respondidas.
  #
  # ==== Efeitos colaterais
  # - Cria múltiplos registros no banco de dados na tabela +respostas+.
  # - Redireciona para a view do formulário com alertas ou mensagens de sucesso.
  #
  # ==== Possíveis retornos
  # * Redireciona com alerta caso o usuário já tenha respondido.
  # * Redireciona com alerta caso falte alguma resposta.
  # * Redireciona com sucesso após salvar todas as respostas.
  def create
    formulario = Formulario.find(params[:formulario_id])

    if Resposta.exists?(formulario_id: formulario.id, aluno_id: current_user.id)
      redirect_to formulario_path(formulario), alert: "Você já respondeu este formulário."
      return
    end

    respostas_params = params.require(:respostas).permit!.to_h
    perguntas = formulario.template.formulario["perguntas"]
    erros = []

    perguntas.each_with_index do |_, i|
      resposta = respostas_params[i.to_s]
      if resposta.nil? || resposta["conteudo"].blank?
        erros << "Pergunta #{i + 1} não foi respondida."
      end
    end

    if erros.any?
      redirect_to formulario_path(formulario), alert: "⚠️ Responda todas as perguntas antes de enviar o formulário."
      return
    end

    respostas_params.each do |_, resposta|
      Resposta.create!(
        formulario_id: formulario.id,
        aluno_id: current_user.id,
        pergunta_index: resposta["pergunta_index"],
        conteudo: resposta["conteudo"]
      )
    end

    redirect_to formulario_path(formulario), notice: "Respostas enviadas com sucesso! 📝"
  end
end
