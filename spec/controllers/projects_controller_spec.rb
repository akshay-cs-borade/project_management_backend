require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }  # Create a user with FactoryBot
  let(:valid_attributes) { { name: "New Project", start_date: Date.today + 1.day, duration: 12 } }
  let(:invalid_attributes) { { name: "", start_date: "", duration: nil } }  # Invalid attributes to trigger model validation errors
  let(:project) { create(:project, valid_attributes) }

  before do
    sign_in user  # Sign in the user if you're using Devise
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new project and returns a success response" do
        expect {
          post :create, params: { project: valid_attributes }
        }.to change(Project, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('New Project')
        expect(json_response['duration']).to eq(12)
      end
    end

    context "with invalid attributes" do
      it "does not create a new project and returns an error response" do
        expect {
          post :create, params: { project: invalid_attributes }
        }.to_not change(Project, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include("Name can't be blank", "Start date can't be blank", "Duration can't be blank")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the requested project and returns a success response" do
        patch :update, params: { id: project.id, project: { name: "Updated Project", start_date: "2025-02-01", duration: 24 } }

        project.reload
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Updated Project')
        expect(json_response['start_date']).to eq('2025-02-01')
        expect(json_response['duration']).to eq(24)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested project and returns an error response" do
        patch :update, params: { id: project.id, project: { name: "", start_date: "", duration: nil } }

        project.reload
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include("Name can't be blank", "Start date can't be blank", "Duration can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested project and returns a success response" do
      project_to_delete = create(:project, valid_attributes)

      expect {
        delete :destroy, params: { id: project_to_delete.id }
      }.to change(Project, :count).by(-1)

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Project deleted')
    end
  end
end
