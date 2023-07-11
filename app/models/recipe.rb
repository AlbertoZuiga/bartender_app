class Recipe < ApplicationRecord
    has_and_belongs_to_many :ingredients
    has_many :ratings
    has_and_belongs_to_many :users, throught: :ratings


    validates :name, presence: true
end
