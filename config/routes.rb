Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get 'admin/active_projects', to: 'admins#active_projects'
  post '/admin/update_project_users', to: 'admins#update_project_users'
  get 'admin/project_task_duration/:project_id', to: 'admins#project_task_duration'
  get 'admin/users', to: 'admins#users'
  get 'admin/user_projects_and_tasks/:id', to: 'admins#user_projects_and_tasks'
  

  get 'user/projects', to: 'users#projects'
  post 'user/tasks', to: 'users#add_task'
  get 'user/tasks', to: 'users#tasks'
end
