class Project < ApplicationRecord
  has_many :projects_users
  has_many :users, through: :projects_users
  has_many :tasks

  def active?
    start_date <= Date.today && (start_date + duration.days) >= Date.today
  end
end
