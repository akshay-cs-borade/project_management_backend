class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def create
    project = Project.new(project_params)
    if project.save
      render json: project, status: :created
    else
      render json: { error: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    project = Project.find(params[:id])
    if project.update(project_params)
      render json: project, status: :ok
    else
      render json: { error: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    render json: { message: "Project deleted" }, status: :ok
  end

  private

  def project_params
    params.require(:project).permit(:name, :start_date, :duration)
  end
end
