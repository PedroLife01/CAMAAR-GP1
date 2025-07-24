##
# Controller responsável por gerenciar o vínculo entre alunos e turmas.
#
# Utiliza rotas aninhadas no formato `/turmas/:turma_id/alunos/...`.
# Permite criar e destruir vínculos entre `User` (aluno) e `Turma`.
class TurmasAlunosController < ApplicationController
  before_action :set_turma

  ##
  # Cria o vínculo entre um aluno e a turma, se ainda não existir.
  #
  # ==== Parâmetros
  # * +params[:turma_id]+ - ID da turma onde o aluno será adicionado.
  # * +params[:aluno_id]+ - ID do aluno a ser vinculado.
  # * +params[:q]+ - (opcional) termo de busca, usado para manter a query ao redirecionar.
  #
  # ==== Retorno
  # Redireciona para a página da turma com status 303 (See Other).
  #
  # ==== Efeitos colaterais
  # * Cria um registro em `TurmasAluno` (vínculo aluno-turma) se não existir.
  # * Define `flash[:notice]` ou `flash[:alert]` conforme o caso.
  def create
    aluno = User.find(params[:aluno_id])

    if @turma.alunos.include?(aluno)
      flash.now[:alert] = "Este aluno já está vinculado à turma."
    else
      @turma.alunos << aluno
      flash.now[:notice] = "Aluno vinculado com sucesso."
    end

    redirect_to turma_path(@turma, q: params[:q]), status: :see_other
  end

  ##
  # Remove o vínculo entre o aluno e a turma.
  #
  # ==== Parâmetros
  # * +params[:turma_id]+ - ID da turma do vínculo.
  # * +params[:id]+ - ID do vínculo `TurmasAluno` que será destruído.
  #
  # ==== Retorno
  # - Em caso de requisição Turbo Stream, atualiza a view dinamicamente.
  # - Em HTML, redireciona para a página da turma.
  #
  # ==== Efeitos colaterais
  # * Remove o vínculo entre o aluno e a turma do banco de dados.
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
  # Define a turma com base no parâmetro `turma_id`.
  #
  # ==== Efeitos colaterais
  # * Define a variável @turma para uso interno nas actions.
  def set_turma
    @turma = Turma.find(params[:turma_id])
  end
end
