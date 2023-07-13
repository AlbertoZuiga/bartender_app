class StaticPagesController < ApplicationController
    def home
        @ingredients = Ingredient.all
    end
end