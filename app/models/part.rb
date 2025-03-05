class Part < ApplicationRecord
  belongs_to :user
  belongs_to :flow

  has_many :steps

  validates :name, presence: true
  validates :tag, presence: true
  validates :hiringCompany, presence: true
  validates :description, presence: true
end
