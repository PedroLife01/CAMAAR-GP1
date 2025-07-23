##
# Controller responsável por vincular e desvincular alunos de turmas.
#
# Utiliza nested routes no formato `/turmas/:turma_id/alunos/...`.
class TurmasAlunosController < ApplicationController
  before_action :set_turma

  ##
  # Vincula um aluno à turma, desde que ainda não esteja vinculado.
  #
  # ==== Parâmetros
  # * +params[:turma_id]+ - ID da turma
  # * +params[:aluno_id]+ - ID do aluno a ser vinculado
  # * +params[:q]+ - (opcional) termo de busca que será mantido na query ao redirecionar
  #
  # ==== Efeitos colaterais
  # Cria o vínculo no banco de dados ou exibe alerta caso já exista.
  # Redireciona para a página da turma com status 303.
  def create
    @turma = Turma.find(params[:turma_id])
    aluno = User.find(params[:aluno_id])

    unless @turma.alunos.include?(aluno)
      @turma.alunos << aluno
      flash.now[:notice] = "Aluno vinculado com sucesso."
    else
      flash.now[:alert] = "Este aluno já está vinculado à turma."
    end

    redirect_to turma_path(@turma, q: params[:q]), status: :see_other
  end

  ##
  # Remove o vínculo entre um aluno e a turma.
  #
  # ==== Parâmetros
  # * +params[:turma_id]+ - ID da turma
  # * +params[:id]+ - ID do vínculo (registro de TurmasAluno)
  #
  # ==== Efeitos colaterais
  # Remove o vínculo do banco de dados e atualiza a view via Turbo Stream ou redireciona.
  def destroy
    @turma_aluno = @turma.turmas_alunos.find(params[:id])
    @aluno = @turma_aluno.aluno
    @turma_aluno.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @turma }
    end
  end

  private

  ##
  # Carrega a turma com base no parâmetro +turma_id+.
  #
  # ==== Efeitos colaterais
  # Define a variável @turma para uso nas actions.
  def set_turma
    @turma = Turma.find(params[:turma_id])
  end
end
