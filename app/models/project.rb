class Project < ApplicationRecord
  has_many :projects_users
  has_many :users, through: :projects_users
  has_many :tasks

  validates :name, presence: true, length: { maximum: 100 }
  validates :start_date, presence: true
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Additional optional validations
  validate :start_date_cannot_be_in_the_past

  def active?
    start_date <= Date.today && (start_date + duration.days) >= Date.today
  end

  private

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
  end
end
