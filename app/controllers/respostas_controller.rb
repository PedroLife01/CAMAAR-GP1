class RespostasController < ApplicationController
  before_action :authenticate_user!

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
