# spec/models/project_spec.rb
require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      project = build(:project, name: 'Test Project', start_date: Date.today + 1.day, duration: 10, users: [user])
      expect(project).to be_valid
    end

    it 'is not valid without a name' do
      project = build(:project, name: nil)
      project.valid?
      expect(project.errors[:name]).to include("can't be blank")
    end

    it 'is not valid if the name is too long' do
      project = build(:project, name: 'A' * 101)  # name longer than 100 chars
      project.valid?
      expect(project.errors[:name]).to include("is too long (maximum is 100 characters)")
    end

    it 'is not valid without a start date' do
      project = build(:project, start_date: nil)
      project.valid?
      expect(project.errors[:start_date]).to include("can't be blank")
    end

    it 'is not valid with a start date in the past' do
      project = build(:project, start_date: Date.today - 1.day)
      project.valid?
      expect(project.errors[:start_date]).to include("can't be in the past")
    end

    it 'is not valid without a duration' do
      project = build(:project, duration: nil)
      project.valid?
      expect(project.errors[:duration]).to include("can't be blank")
    end

    it 'is not valid with a non-integer duration' do
      project = build(:project, duration: 'abc')
      project.valid?
      expect(project.errors[:duration]).to include("is not a number")
    end

    it 'is not valid with a duration less than or equal to 0' do
      project = build(:project, duration: 0)
      project.valid?
      expect(project.errors[:duration]).to include("must be greater than 0")
    end
  end

  describe '#active?' do
    it 'returns true if the project is active' do
      project = build(:project, start_date: Date.today - 1.day, duration: 10)
      project.save(validate: false)
      expect(project.active?).to be(true)
    end

    it 'returns false if the project has not started yet' do
      project = create(:project, start_date: Date.today + 1.day, duration: 10)
      expect(project.active?).to be(false)
    end

    it 'returns false if the project has ended' do
      project = build(:project, start_date: Date.today - 10.days, duration: 1)
      project.save(validate: false)
      expect(project.active?).to be(false)
    end
  end
end
