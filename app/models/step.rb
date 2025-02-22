class Step < ApplicationRecord
  belongs_to :user
  belongs_to :flow
  belongs_to :part, optional: true

  validates :name, presence: true
end
