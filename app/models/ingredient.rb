class Ingredient < ApplicationRecord
    has_and_belongs_to_many :recipes

    validates :name, presence: true
end
