Rails.application.routes.draw do
  resource :sessions

  get "signup" => "users#new"
  resources :users
  root "events#index"
  
  resources :events do
    resources :registrations
  end
end
