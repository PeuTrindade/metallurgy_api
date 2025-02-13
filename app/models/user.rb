class User < ApplicationRecord
  has_many :steps
  has_many :parts
  has_many :flows
  
  has_secure_password
  
  validates :email, presence: true, uniqueness: true
end
