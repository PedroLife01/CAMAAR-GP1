class TurmasAlunosController < ApplicationController
  before_action :set_turma

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

  def set_turma
    @turma = Turma.find(params[:turma_id])
  end
end
