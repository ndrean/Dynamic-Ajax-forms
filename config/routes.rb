Rails.application.routes.draw do

  root to: 'pages#home'


  
  #get 'genres/fetch_create'
  

  

  resources :genres, only: [:new, :create, :index, :destroy] do
    resources :restos, only: [ ] do
      resources :comments, only: []
    end
  end

  patch 'genres/set_genre_to_resto'
  # custom route for the Fetch API
  delete 'deleteFetch/:id', to: 'genres#deleteFetch'


  resources :restos, only: [:new, :create, :index, :update, :destroy]
  patch 'updateGenre', to:'restos#updateGenre'
  

  resources :comments, only: [:index, :new,:create, :edit, :update, :destroy]
  get 'comments/new_resto_on_the_fly'
  post 'comments/create_resto_on_the_fly'

  resource :nests, only: [:new, :create] 
  post 'nests/create_genre'
  patch 'nests/update_genre'
  post 'nests/create_resto'
end
