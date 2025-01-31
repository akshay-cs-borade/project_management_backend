require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  let(:admin_user) { create(:user, :admin) }  # Assuming you have a FactoryBot trait for admin users
  let(:regular_user) { create(:user) }
  let(:valid_attributes) { { name: "New Project", start_date: Date.today + 1.day, duration: 12 } }
  let(:project) { create(:project, valid_attributes) }
  let(:task) { create(:task, project: project) }
  
  before do
    sign_in admin_user  # Sign in as an admin user for admin actions
  end

  describe "GET #active_projects" do
    it "returns active projects" do
      active_project = create(:project, valid_attributes)
      inactive_project = create(:project, { name: "New Project", start_date: Date.today, duration: 12 })
      
      get :active_projects
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)  # Only active projects should be included
      expect(json_response[0]['name']).to eq(active_project.name)
    end
  end

  describe "GET #project_task_duration" do
    it "returns tasks and total duration of a project" do
      create(:task, project: project, duration: 5)
      create(:task, project: project, duration: 3)

      get :project_task_duration, params: { project_id: project.id }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['tasks'].length).to eq(2)  # 2 tasks
      expect(json_response['total_duration']).to eq(8)  # 5 + 3 duration
    end
  end

  describe "GET #users" do
    it "returns users with a user role" do
      user = create(:user, :user)  # Assuming you have a FactoryBot trait for user role
      admin = create(:user, :admin)
      
      get :users

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)  # Only users with the :user role should be returned
      expect(json_response[0]['id']).to eq(user.id)
    end
  end

  describe "GET #user_projects_and_tasks" do
    it "returns a user's projects and their tasks" do
      user = create(:user)
      project_with_task = create(:project, valid_attributes)
      create(:projects_user, user: user, project: project_with_task)  # Assuming you have a join model for user-project relation
      task = create(:task, project: project_with_task)

      get :user_projects_and_tasks, params: { id: user.id }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response[0]['project_name']).to eq(project_with_task.name)
      expect(json_response[0]['tasks'].length).to eq(1)
      expect(json_response[0]['tasks'][0]['task_name']).to eq(task.name)
    end
  end

  describe "PATCH #update_project_users" do
    context "when project is found" do
      it "updates users for the project" do
        user1 = create(:user)
        user2 = create(:user)
        
        post :update_project_users, params: { project_id: project.id, user_ids: [user1.id, user2.id] }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Users updated successfully')
        expect(json_response['users'].length).to eq(2)
      end
    end

    context "when project is not found" do
      it "returns an error when project is not found" do
        post :update_project_users, params: { project_id: 999, user_ids: [1, 2] }
        
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Project not found')
      end
    end

    context "when some users are not found" do
      it "returns an error when some users are not found" do
        post :update_project_users, params: { project_id: project.id, user_ids: [999] }
        
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Some users not found')
      end
    end
  end

  describe "Authorization" do
    context "when user is not an admin" do
      before do
        sign_in regular_user  # Sign in as a regular user
      end

      it "returns forbidden error on admin restricted actions" do
        get :active_projects
        expect(response).to have_http_status(:forbidden)
        
        get :project_task_duration, params: { project_id: project.id }
        expect(response).to have_http_status(:forbidden)
        
        post :update_project_users, params: { project_id: project.id, user_ids: [regular_user.id] }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
