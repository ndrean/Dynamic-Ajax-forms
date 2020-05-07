Rails.application.routes.draw do
  root to: 'nests#new'
  get 'nests/new'
  post 'nests/create'

  get 'comments/new'
  post 'comments/create'
  get 'comments/newResto'
  post 'comments/create_resto'
  patch 'restos/:id', to: 'restos#update'

  patch 'restos/:resto_id/comments/:id', to: 'comments#save_edit' 

  resources :restos do
    resources :comments, only: [:new, :create, :show, :edit]
    end
  resources :comments, only: [:index, :destroy, :update]
end
