class User < ApplicationRecord
  enum role: { admin: 0, user: 1 }
  has_many :projects_users
  has_many :projects, through: :projects_users

  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
end
