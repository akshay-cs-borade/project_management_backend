# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Test for enum roles
  it { should define_enum_for(:role).with_values([:admin, :user]) }

  # Test for associations
  it { should have_many(:projects_users) }
  it { should have_many(:projects).through(:projects_users) }

  # You may also want to test your custom JWT strategy
  it { should have_db_column(:role).of_type(:integer) } # if you want to check the database column type
end
