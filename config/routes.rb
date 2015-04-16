Rails.application.routes.draw do
  get 'static_pages/dash'

  resources :stories do
    resources :films do
      resources :hotspots
    end
  end

  get 'contact',    to: 'static_pages#contact'
  get 'terms',      to: 'static_pages#terms'
  get 'privacy',    to: 'static_pages#privacy'
  get 'submission', to: 'static_pages#submission'
  match 'stories/:id/path',     to: 'stories#path',     via: [:get], as: :path
  match 'stories/:id/network',  to: 'stories#network',  via: [:get], as: :network

  match 'dash',                 to: 'users#dash',       via: [:get], as: :dash
  devise_for :users, :controllers => {
    :omniauth_callbacks => "omniauth_callbacks",
    registrations: 'users/registrations'
  }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  root to: "static_pages#home"

  # get "*any", via: :all, to: "errors#not_found" #404 - Creates issues with reflie
end
