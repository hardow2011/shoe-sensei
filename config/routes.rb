Rails.application.routes.draw do


  constraints subdomain: '' do
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    devise_for :users, path: '',
    module: 'users/devise',
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

      get 'policies/privacy', to: 'pages#privacy_policy'
      get 'policies/terms', to: 'pages#terms_of_use'

      resources :posts, only: %i[show index], path: 'blog', as: 'posts' do
        resources :comments do
          get 'replies', shallow: true
        end
      end

      resources :brands, only: %i[show index]
      # get 'collections/:brand_id/:id', to: 'collections#show', as: 'collection'
      # get 'models/:brand_id/:collection_id/:id', to: 'models#show', as: 'model'
    end

    # error pages
    %w( 404 422 500 503 ).each do |code|
      get code, :to => "errors#show", :code => code
    end
  end

  # admin.localhost:3000
  constraints subdomain: 'admin' do
      devise_for :admins, class_name: 'User', path: '',
        module: 'admin/devise',
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
