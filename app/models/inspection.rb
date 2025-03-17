class Inspection < ApplicationRecord
  belongs_to :user
  belongs_to :flow
  belongs_to :part

  validates :description, presence: true
end
