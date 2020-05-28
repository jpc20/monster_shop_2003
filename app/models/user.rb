class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  validates_presence_of :password, on: :create
  validates :email, uniqueness: true, presence: true
  validates_confirmation_of :password
  has_secure_password
  enum role: %w(default merchant admin)
end
