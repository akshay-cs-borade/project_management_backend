# spec/models/projects_user_spec.rb
require 'rails_helper'

RSpec.describe ProjectsUser, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, name: 'Test Project', start_date: Date.today + 1.day, duration: 10, users: [user]) }
  let(:projects_user) { create(:projects_user, user: user, project: project) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(projects_user).to be_valid
    end

    it 'is invalid without a user' do
      projects_user.user = nil
      expect(projects_user).to_not be_valid
    end

    it 'is invalid without a project' do
      projects_user.project = nil
      expect(projects_user).to_not be_valid
    end
  end
end
