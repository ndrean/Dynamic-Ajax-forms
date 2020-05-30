Rails.application.routes.draw do

  root to: 'pages#home'
  get 'pages/queries'

  # cURL tests : 
  match '/example', to: 'pages#home', via: :get
  # >curl -X GET -d "pl=wtf" http://localhost:3000/home
  


  resources :genres, only: [:new, :create, :index, :destroy, :update] do
    resources :restos, only: [ ] do
      resources :comments, only: []
    end
  end

  resources :clients, only: [:index]

  
  #get '/genres/:id', to: 'comments#display'
  get 'genres/new4'
  post 'genres/create4'
  
  patch 'setGenre', to: 'genres#set_genre_to_resto'

  # custom route for the Fetch API
  delete 'deleteFetch/:id', to: 'genres#deleteFetch'

  get 'comments/display'
  post 'comments/save_display'
  patch 'comments/update_display'

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
