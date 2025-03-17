class User < ApplicationRecord
  has_many :steps
  has_many :parts
  has_many :flows
  has_many :steps_flows
  has_many :inspections
  
  has_secure_password
  
  validates :email, presence: true, uniqueness: true
end
