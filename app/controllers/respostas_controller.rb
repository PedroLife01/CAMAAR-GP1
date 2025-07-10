class RespostasController < ApplicationController
  before_action :authenticate_user!

  def create
    formulario = Formulario.find(params[:formulario_id])

    if Resposta.exists?(formulario_id: formulario.id, aluno_id: current_user.id)
      redirect_to formulario_path(formulario), alert: "Você já respondeu este formulário."
      return
    end

    respostas_params = params.require(:respostas).permit!.to_h # <- aqui é o segredo!

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
