class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy save]

  def index
    @recipes = Recipe.all
  end

  def search
    query = params[:query].downcase
    if query.size > 0
      recipes = Recipe.joins(:ingredients).where("lower(recipes.name) LIKE :query OR lower(ingredients.name) LIKE :query", query: "%#{query}%").distinct.select(:id, :name)
    else
      recipes = []
    end

    render json: { recipes: recipes }
  end

  def save
    @rating = Rating.where(recipe: @recipe, user: current_user).first
    if @rating == nil
      Rating.create(recipe: @recipe, user: current_user, favorite: params[:format])
    else
      @rating.update(favorite: params[:format])
    end
    redirect_to recipe_path(@recipe)
  end

  def show
      @recipe = Recipe.find(params[:id])
  end

  def new
      @recipe = Recipe.new
  end

  def edit
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    
    ingredients = params["recipe"]["recipe_ingredients"].split(",")
    ingredients = ingredients.map(&:upcase)
    for ingredient in ingredients
      @recipe.ingredients << Ingredient.find_or_create_by(name: ingredient)
    end
    
    respond_to do |format|
      if @recipe.save

        format.html { redirect_to recipe_url(@recipe), notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    ingredients = params["recipe"]["recipe_ingredients"].split(",")
    ingredients = ingredients.map(&:upcase)
    for ingredient in ingredients
      @recipe.ingredients << Ingredient.find_or_create_by(name: ingredient)
    end
    
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_url(@recipe), notice: "Recipe was successfully updated." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: "Recipe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :description, :instruction)
  end
end
