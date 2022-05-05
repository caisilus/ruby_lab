Rails.application.routes.draw do
  root 'course#index'

  # authentication
  # get '/auth', to: 'auth#new'
  # post '/auth', to: "auth#create"
  # post '/auth/microsoft', to: 'auth#microsoft'
  # post '/auth/github', to: 'auth#github'
  # delete '/auth', to: 'auth#destroy'

  # registration
  # post '/users', to: 'users#create'

  get '/course', to: 'course#index' # general course information

  # labs
  get '/labs/:id', to: 'labs#show', as: 'lab'
  get '/labs', to: 'labs#index'

  # tasks
  get '/tasks/new', to: 'task#new'
  post '/tasks', to: 'task#create'

  # ------------ for logged in users ------------

  # results
  get '/results', to: 'results#index'

  # ------------ Github routes -----------
  get '/repository/new', to: "repository#new"
  post '/repository', to: "repository#create"
  post 'webhook/payload', to: "payload#create"

end
