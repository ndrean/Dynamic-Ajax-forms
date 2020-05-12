Rails.application.routes.draw do

  root to: 'pages#home'

  resources :genres, only: [:new, :index, :destroy]
  #get 'genres/new'
  #get 'genres/create'
  #delete 'genres/destroy'
  post 'genres/create'

  #get 'genres/index'

  patch 'genres/set_genre_to_resto'
  #get 'genres/fetch_create'
  
  #delete 'genres/destroy'
  patch 'updateGenre', to:'restos#updateGenre'

  # custom route for the Fetch API
  delete 'deleteFetch/:id', to: 'genres#deleteFetch'

  resources :restos do
    resources :comments, only: [:show, :edit]
    end

  resources :comments, only: [:index, :destroy, :update, :new, :create]
  #post 'comments/create' if <%= simple_form_for @comment, url: 'comments/create' is precised
  get 'comments/new_resto_on_the_fly'
  post 'comments/create_resto_on_the_fly'

  resource :nests, only: [:new]
  post 'nests/createDyn'
  post 'nests/createNested'
end
