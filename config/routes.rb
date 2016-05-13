Rails.application.routes.draw do
  get '' => 'rooms#index'
  get 'members' => 'rooms#members'
  post '/sessions' => 'sessions#create'

end
