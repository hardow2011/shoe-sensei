Rails.application.routes.draw do


  constraints subdomain: '' do
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    devise_for :users, path: '',
    controllers: { sessions: 'users/devise/sessions',
                    registrations: 'users/devise/registrations' },
    path_names: { sign_in: 'login', sign_out: 'logout',
                  registration: 'signup', sign_up: '',
                  confirmation: 'verification' }
    # path_names: { sign_in: 'login', sign_out: 'logout',
    #               password: 'secret', confirmation: 'verification',
    #               unlock: 'unblock', registration: 'signup',
    #               sign_up: '' }

    # Defines the root path route ("/")
    # get '/:locale' => "pages#home"

    scope "(:locale)", locale: /en|es/ do
      root "pages#home"

      get 'filter_models', to: 'pages#filter_models', as: 'filter_models'

      resources :posts, only: %i[show index], path: 'blog', as: 'posts'

      resources :brands, only: %i[show index]
      # get 'collections/:brand_id/:id', to: 'collections#show', as: 'collection'
      # get 'models/:brand_id/:collection_id/:id', to: 'models#show', as: 'model'
    end
  end

  # admin.localhost:3000
  constraints subdomain: 'admin' do
      devise_for :admins, class_name: 'User', path: '',
        controllers: { sessions: 'admin/devise/sessions' },
        path_names: { sign_in: 'login', sign_out: 'logout',
                      registration: 'signup', sign_up: '' }
        # path_names: { sign_in: 'login', sign_out: 'logout',
        #               password: 'secret', confirmation: 'verification',
        #               unlock: 'unblock', registration: 'register',
        #               sign_up: 'signup' }
    namespace :admin, path: '' do
      get '', to: 'pages#home'
      resources :brands, except: %i[show]
      resources :collections, except: %i[show]
      resources :models, except: %i[show]
      resources :posts, except: %i[show]
      post '/tinymce_assets' => 'tinymce_assets#create'
    end
  end
end
