Rails.application.routes.draw do


  root 'static_pages#home' #needs action not url thats why home_path doesnt work
  get '/help', to: 'static_pages#help', as: 'help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  #patch "/users/:id/edit", to: "users#update" as 'update'   GAH! FUCK! whatever its not a huge deal.
  #how to make sow /edit doesnt dissapear after failed patch/put
  #can copy and paste urls able to edit other users
  resources :users do#, :except => :update
    member do
      get :following, :followers  #???
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:edit, :create, :new, :update]
  #add update?
  resources :microposts, only: [ :destroy]
  post '/', to: 'microposts#create', as: 'microposts'
  #GONNA LEARN HOW TO MODIFY URL!!!
      # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :relationships, only: [:create, :destroy]
  resources :shares, only: [:create, :destroy]
end
