Rails.application.routes.draw do
  root to: 'nests#new'
  get 'nests/new'
  post 'nests/create'

  get 'comments/new'
  post 'comments/create'
  get 'comments/newResto'
  post 'comments/create_resto'
  
  resources :restos do
    resources :comments, only: [:new, :create, :show, :edit, :update]
    end
  resources :comments, only: [:index, :destroy]
end
