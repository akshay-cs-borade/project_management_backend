class UsersController < ApplicationController
  before_action :authenticate_user!

  # Fetch projects assigned to the logged-in user
  def projects
    render json: current_user.projects.includes(:tasks), include: :tasks
  end

  # Add a task to a project (only if it's active)
  def add_task
    project = current_user.projects.find_by(id: params[:task][:project_id])

    if project.nil?
      return render json: { error: 'Project not found or not assigned to you' }, status: :not_found
    end

    unless project.active?
      return render json: { error: 'Project is not active' }, status: :unprocessable_entity
    end

    task = project.tasks.create(task_params)
    
    if task.persisted?
      render json: task, status: :created
    else
      render json: { error: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def me
    render json: { id: current_user.id, name: current_user.name, email: current_user.email }
  end
  
  private

  def task_params
    params.require(:task).permit(:name, :description, :start_time, :end_time, :duration)
  end
end
