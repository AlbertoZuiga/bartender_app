class RecipesController < ApplicationController
  load_and_authorize_resource
  before_action :set_recipe, only: %i[ show edit update destroy save rate]

  def index
    @recipes = Recipe.all.sort_by { |recipe| recipe.rating.nil? ? 0 : recipe.rating }.reverse
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

  def find
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

  def save
    rating = Rating.where(recipe: @recipe, user: current_user).first
    if rating == nil
      Rating.create(recipe: @recipe, user: current_user, favorite: params[:recipe][:format])
    else
      rating.update(favorite: params[:recipe][:checked])
    end
    render json: { rating: rating }
  end
  
  def rate
    rating = Rating.where(recipe: @recipe, user: current_user).first
    if rating == nil
      Rating.create(recipe: @recipe, user: current_user, rate: params[:rating])
    else
      rating.update(rate: params[:rating])
    end
    render json: { rating: @recipe.rating }
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    rate = @recipe.ratings.where(user: current_user).first
    if rate
      @rate = rate.rate
    else
      @rate = nil
    end
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
