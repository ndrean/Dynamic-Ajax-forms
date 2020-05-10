Rails.application.routes.draw do
  get 'genres/new'
  get 'genres/create'
  get 'genres/delete'
  root to: 'pages#home'
  
  
  #resources :genres, only: [:new, :create, :destroy]
  #get 'genres/new'
  post 'genres/create'
  get 'genres/index'

  post 'genres/set_genres_to_resto'
  get 'genres/fetch_create'
  get 'genres/fetch_delete'


  resources :restos do
    resources :comments, only: [:show, :edit]
    end

  resources :comments, only: [:index, :destroy, :update, :new, :create]
  #post 'comments/create' if <%= simple_form_for @comment, url: 'comments/create' is precised
  get 'comments/new_resto_on_the_fly'
  post 'comments/create_resto_on_the_fly'

  resource :nests, only: [:new, :create]
  get 'nests/new'
  post 'nests/create'
end
