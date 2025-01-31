require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:project) { create(:project, { name: "New Project", start_date: Date.today + 1.day, duration: 12, users: [user]}) }
  let!(:active_project) { build(:project, { name: "New Project", start_date: Date.today - 1.day, duration: 12, users: [user]}) }
  let!(:task) { create(:task, project: active_project) }
  
  before do
    sign_in user  # Assuming Devise or a similar gem is used for authentication
  end

  describe "GET #projects" do
    it "returns the list of projects assigned to the logged-in user" do
      active_project.save(validate: false)
      get :projects
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(2)  # Should include both active and non-active projects
    end
  end

  describe "POST #add_task" do
    context "when the project is found and active" do
      it "adds a new task to the project" do
        active_project.save(validate: false)
        task_params = { name: "New Task", description: "Task description", start_time: "2025-01-01 09:00:00", end_time: "2025-01-01 17:00:00", duration: 8, project_id: active_project.id }
        
        post :add_task, params: { task: task_params }
        
        expect(response).to have_http_status(:created)
        expect(json_response['name']).to eq('New Task')
        expect(active_project.tasks.count).to eq(1)
      end
    end

    context "when the project is not found" do
      it "returns an error message" do
        task_params = { name: "New Task", description: "Task description", start_time: "2025-01-01 09:00:00", end_time: "2025-01-01 17:00:00", duration: 8, project_id: 999 }
        
        post :add_task, params: { task: task_params }
        
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Project not found or not assigned to you')
      end
    end

    context "when the project is not active" do
      it "returns an error message" do
        task_params = { name: "New Task", description: "Task description", start_time: "2025-01-01 09:00:00", end_time: "2025-01-01 17:00:00", duration: 8, project_id: project.id }
        
        post :add_task, params: { task: task_params }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('Project is not active')
      end
    end
  end

  describe "GET #me" do
    it "returns the details of the logged-in user" do
      get :me
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(user.id)
      expect(json_response['name']).to eq(user.name)
      expect(json_response['email']).to eq(user.email)
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
