class User < ApplicationRecord
  enum access_level: [:employee, :manager, :admin]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :token_authenticatable

  has_many :authentication_tokens, dependent: :delete_all
  has_many :tasks, dependent: :delete_all

  validates_presence_of :username

  validates :preferred_working_hours_per_day, numericality: { greater_than: 0, less_than_or_equal_to: 24 * 60 }
end
