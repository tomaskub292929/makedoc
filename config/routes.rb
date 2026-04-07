Rails.application.routes.draw do
  root 'pages#home'

  get '/about', to: 'pages#about'
  get '/medical_schools', to: 'pages#medical_schools'
  get '/news', to: 'pages#news'
  get '/building', to: 'pages#building'
  get '/reservation', to: 'pages#reservation'
  get '/reviews', to: 'pages#reviews'
  get '/directions', to: 'pages#directions'

  get "up" => "rails/health#show", as: :rails_health_check
end
