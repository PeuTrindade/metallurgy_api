class Suggestion < ApplicationRecord
  belongs_to :user
  belongs_to :flow
  belongs_to :part
end
