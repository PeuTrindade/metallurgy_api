class StepsFlow < ApplicationRecord
  belongs_to :user
  belongs_to :flow

  validates :name, presence: true
end
