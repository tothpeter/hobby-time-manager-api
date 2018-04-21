class Task < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :title, :duration, :date

  validates :duration, numericality: { greater_than: 0, less_than_or_equal_to: 24 * 60 }

  scope :between_dates, lambda { |start_date, end_date| where("date BETWEEN ? AND ?", start_date, end_date) }
  scope :by_user_id, lambda { |user_id| where("user_id = ?", user_id) }
end
