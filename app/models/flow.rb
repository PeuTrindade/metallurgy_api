class Flow < ApplicationRecord
  belongs_to :user

  has_many :parts
  has_many :steps
  has_many :steps_flows
  has_many :inspections
  has_many :comments
  has_many :suggestions

  validates :name, presence: true
  validates :description, presence: true
end
