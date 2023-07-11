class Recipe < ApplicationRecord
    has_and_belongs_to_many :ingredients
    has_many :ratings

    def rating
        self.ratings.average(:rate)
    end
    validates :name, presence: true
end
