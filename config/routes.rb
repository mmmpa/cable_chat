Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get ''           => 'rooms#index'
  post '/sessions' => 'sessions#create'
end
