Rails.application.routes.draw do
  root to: 'pages#home'
  
  
  

  resources :restos do
    resources :comments, only: [:show, :edit]
    end

  resources :comments, only: [:index, :destroy, :update, :new, :create]
  #post 'comments/create' if <%= simple_form_for @comment, url: 'comments/create' is precised
  get 'comments/new_resto_on_the_fly'
  post 'comments/create_resto_on_the_fly'

  resource :nests, only: [:new, :create]
  #get 'nests/new'
  #post 'nests/create'
end
