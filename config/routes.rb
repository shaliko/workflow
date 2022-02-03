require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
end

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # define your application routes per the dsl in https://guides.rubyonrails.org/routing.html

  # defines the root path route ("/")
  # root "articles#index"

  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      resources :workflows, only: %i[index show create]
      resources :workflow_instances, only: %i[index show create] do
        post :run, on: :collection
      end
    end
  end

end
