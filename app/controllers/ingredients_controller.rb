class IngredientsController < ApplicationController
  load_and_authorize_resource
  before_action :set_ingredient, only: %i[ show edit update destroy]

  def index
      @ingredients = Ingredient.all
  end

  def show
  end

  def new
      @ingredient = Ingredient.new
  end

  def edit
  end

  def create
      @ingredient = Ingredient.new(ingredient_params)

      respond_to do |format|
          if @ingredient.save
            format.html { redirect_to ingredient_url(@ingredient), notice: "Ingredient was successfully created." }
            format.json { render :show, status: :created, location: @ingredient }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @ingredient.errors, status: :unprocessable_entity }
          end
      end
  end

  def update
      respond_to do |format|
          if @ingredient.update(ingredient_params)
            format.html { redirect_to ingredient_url(@ingredient), notice: "Ingredient was successfully created." }
            format.json { render :show, status: :created, location: @ingredient }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @ingredient.errors, status: :unprocessable_entity }
          end
      end
  end

  def destroy
    @ingredient.destroy

    respond_to do |format|
      format.html { redirect_to ingredients_url, notice: "Ingredient was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def remove_from_recipe
    recipe = Recipe.find(params[:recipe_id]) # receta correcta
    ingredient = recipe.ingredients.find(params[:id])
    recipe.ingredients.delete(ingredient)

    redirect_to recipe_path(recipe), notice: 'Ingredient deleted correctly from recipe.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
end
