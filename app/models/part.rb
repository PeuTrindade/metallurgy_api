class Part < ApplicationRecord
  belongs_to :user
  belongs_to :flow

  validates :name, presence: true
  validates :tag, presence: true
  validates :hiringCompany, presence: true
end
