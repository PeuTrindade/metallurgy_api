class Flow < ApplicationRecord
  belongs_to :user

  has_many :parts
  has_many :steps
  has_many :steps_flows

  validates :name, presence: true
  validates :description, presence: true
end
