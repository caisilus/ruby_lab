Rails.application.routes.draw do
  root 'course#index'

  get '/course', to: 'course#index' # general course information

  # labs
  get '/labs/:id', to: 'labs#show', as: 'lab'
  get '/labs', to: 'labs#index'

  # ------------ Github routes -----------
  get '/auth/github/new', to: "github_auth#new"
  get '/auth/github/callback', to: "github_auth#callback"
  get '/users/new', to: "users#new"
  post '/users', to: "users#create"
  get '/repository/new', to: "repository#new"
  post '/repository', to: "repository#create"
  post '/payload', to: "payload#create"
end
