class StaticPagesController < ApplicationController
    skip_before_action :authenticate_user!

    def home
        @ingredients = Ingredient.all
    end
    
    def find_recipes
        ingredient = Ingredient.find(params[:ingredient][:ingredient_id])
        if params[:ingredient][:checked]
            current_user.ingredients << ingredient
        else
            current_user.ingredients.delete(ingredient)
        end
        ingredients_ids = current_user.ingredients.pluck(:id)

        recipes = Recipe.all
        selected = []
        recipes.each do |recipe|
            recipe_ingredients_ids = recipe.ingredients.pluck(:id)
            if recipe_ingredients_ids.all? { |elemento| ingredients_ids.include?(elemento) }
                selected.push({ name: recipe.name, link: recipe_path(recipe) })
            end
        end

        render json: { recipes: selected }
    end
end