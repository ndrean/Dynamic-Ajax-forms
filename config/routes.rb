Rails.application.routes.draw do

  root to: 'pages#home'
  get 'pages/queries'

  resources :genres, only: [:new, :create, :index, :destroy, :update] do
    resources :restos, only: [ ] do
      resources :comments, only: []
    end
  end

  #get 'genres/fetch_create'
  get 'genres/new4'
  post 'genres/create4'
  
  patch 'setGenre', to: 'genres#set_genre_to_resto'

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

  resource :clients, only: [:index]
end
