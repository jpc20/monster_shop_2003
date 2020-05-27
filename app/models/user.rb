class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :password
  validates :email, uniqueness: true, presence: true
  has_secure_password
end
