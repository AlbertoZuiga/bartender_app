class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :user, :recipe, presence: true
end
