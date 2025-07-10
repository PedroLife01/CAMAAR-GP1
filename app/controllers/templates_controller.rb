class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_docente!
  before_action :set_template, only: [:edit, :update, :destroy, :show]
  before_action :check_if_in_use, only: [:edit, :update, :destroy]

  def index
    @templates = Template.includes(:user).order(created_at: :desc)
  end

  def show
    @template = Template.find(params[:id])
  end

  def new
    @template = Template.new
  end

  def create
    params[:template][:formulario] = JSON.parse(params[:template][:formulario]) if params[:template][:formulario].is_a?(String)

    @template = current_user.templates.build(template_params)
    if @template.save
      redirect_to templates_path, notice: "Template criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @template = Template.find(params[:id])
  end

  def update
    params[:template][:formulario] = JSON.parse(params[:template][:formulario]) if params[:template][:formulario].is_a?(String)

    if @template.update(template_params)
      redirect_to templates_path, notice: "Template atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
    redirect_to templates_path, notice: "Template excluído com sucesso!"
  end

  private

  def check_docente!
    redirect_to root_path unless current_user.ocupacao == "docente"
  end

  def set_template
    @template = Template.find(params[:id])
  end

  def check_if_in_use
    if @template.formularios.exists?
      redirect_to templates_path, alert: "Este template está sendo utilizado em um formulário e não pode ser alterado ou excluído."
    end
  end

  def template_params
    params.require(:template).permit(:nome, formulario: {})
  end
end
