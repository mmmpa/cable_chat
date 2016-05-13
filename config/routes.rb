Rails.application.routes.draw do
  get '' => 'rooms#index'
  post '/sessions' => 'sessions#create'

end
