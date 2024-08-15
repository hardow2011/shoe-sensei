Rails.application.routes.draw do
  devise_for :users, path: 'admin',
                    controllers: { sessions: 'admin/devise/sessions' },
                    path_names: { sign_in: 'login', sign_out: 'logout',
                                  password: 'secret', confirmation: 'verification',
                                  unlock: 'unblock', registration: 'register',
                                  sign_up: 'signup' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
  get 'filter_models', to: 'pages#filter_models', as: 'filter_models'
  resources :brands, only: %i[show]

  namespace :admin do
    get '', to: 'pages#home', as: 'home'
    resources :collections, except: %i[update edit destroy]
    resources :brands, except: [:show] do
      resources :collections
    end
  end
end
