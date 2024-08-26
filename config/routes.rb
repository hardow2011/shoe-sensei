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
  get '/:locale' => "pages#home"
  root "pages#home"

  scope "(:locale)", locale: /en|es/ do

    namespace :admin do
      get '', to: 'pages#home'
      resources :brands, except: %i[show]
      resources :collections, except: %i[show]
      resources :models, except: %i[show]
    end

    get 'filter_models', to: 'pages#filter_models', as: 'filter_models'
    resources :brands, only: %i[show]
    get 'collections/:brand_id/:id', to: 'collections#show', as: 'collection'
    get 'models/:brand_id/:collection_id/:id', to: 'models#show', as: 'model'
  end
end
