class StaticPagesController < ApplicationController
    def home
        @ingredients = Ingredient.all
    end
    
    def find_recipes
        ingredients_ids = params[:ingredientsId]

        recipes = Recipe.all
        selected = []
        recipes.each do |recipe|
            recipe_ingredients_ids = recipe.ingredients.pluck(:id)
            if recipe_ingredients_ids.all? { |elemento| ingredients_ids.include?(elemento) }
                selected.push(recipe.name)
            end
        end

        render json: { recipes: selected }
    end
end