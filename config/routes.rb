Rails.application.routes.draw do
  root 'home#index'
  get 'new' => 'home#new'
  post 'create' => 'home#create'
  delete 'delete/:id' => 'home#delete'
end
