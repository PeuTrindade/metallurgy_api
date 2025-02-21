class Step < ApplicationRecord
  belongs_to :user
  belongs_to :flow

  validates :name, presence: true
  validates :description, presence: true
end
