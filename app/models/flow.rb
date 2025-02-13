class Flow < ApplicationRecord
  belongs_to :user

  has_many :parts
  has_many :steps

  validates :name, presence: true
  validates :description, presence: true
end
