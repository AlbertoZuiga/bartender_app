Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'static_pages#home'
  resources :ingredients
  resources :recipes

  post 'static_pages/find_recipes', to: 'static_pages#find_recipes'
  get 'search', to: 'recipes#search', as: 'search'
  delete '/recipes/:recipe_id/ingredients/:id/remove', to: 'ingredients#remove_from_recipe', as: 'remove_recipe_ingredient'
end
