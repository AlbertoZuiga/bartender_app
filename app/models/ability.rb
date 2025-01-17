class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    if user.admin?
      can :manage, :all
    else
      can :read, Recipe
      can :save, Recipe
      can :rate, Recipe
      can :find, Recipe
      can :search, Recipe
      can :index, Ingredient
    end
  end
end