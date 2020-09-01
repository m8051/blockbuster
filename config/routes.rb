Rails.application.routes.draw do

  resources :genres
  
  get "signup" => "users#new"
  resources :users
  
  # Custom Routes
  get "movies/filter/:filter" => "movies#index", as: "filtered_movies"
  
  root "movies#index"
  
  # RoR convention for defining all short of routes
  # Nested resource {Chapter 23}
  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  get "signin" => "sessions#new"

  # Specific routes for a singular session resource
  resource :session, only: [:new, :create, :destroy]

  # verb "url" => "name_of_controller#name_of_action"
  # get "movies" => "movies#index"
  # get "movies/new" => "movies#new", as: "add_new_movie"
  # get "movies/:id" => "movies#show", as: "movie"
  # get "movies/:id/edit" => "movies#edit", as: "edit_movie"

  # Route to update/patch the movies into the DB.
  # patch "movies/:id" => "movies#update", as: "update_movie"
  
end
