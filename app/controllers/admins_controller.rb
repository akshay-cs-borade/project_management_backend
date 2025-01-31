class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def active_projects
    projects = Project.includes(:users).all.select(&:active?)
    render json: projects, include: :users
  end

  def project_task_duration
    project = Project.find(params[:project_id])
    tasks = project.tasks.map do |task|
      {
        name: task.name,
        duration: task.duration,
        start_time: task.start_time,
        end_time: task.end_time
      }
    end
    total_duration = project.tasks.sum(:duration)
    render json: { tasks: tasks, total_duration: total_duration }
  end

  def users
    projects = User.all.select(&:user?)
    render json: projects
  end
  
  def user_projects_and_tasks
    user = User.find(params[:id])
    projects = user.projects.includes(:tasks).map do |project|
      {
        project_name: project.name,
        tasks: project.tasks.map do |task|
          {
            task_name: task.name,
            task_duration: task.duration,
            task_start_time: task.start_time,
            task_end_time: task.end_time
          }
        end
      }
    end
    render json: projects
  end

  def update_project_users
    project = Project.find_by(id: params[:project_id])
  
    unless project
      return render json: { error: 'Project not found' }, status: :not_found
    end
  
    # Get the user IDs from the params and find the users
    user_ids = params[:user_ids]
  
    # Find users and check if they exist
    users = User.where(id: user_ids)
  
    if users.count != user_ids.length
      return render json: { error: 'Some users not found' }, status: :not_found
    end
  
    # Assign users to the project
    project.users = users.uniq  # Use .uniq to avoid duplicate assignments
  
    # Respond with success message
    render json: { message: 'Users updated successfully', users: users.as_json(only: [:id, :name]) }
  end

  private

  def authorize_admin!
    render json: { error: 'Access Denied' }, status: :forbidden unless current_user.admin?
  end
end
