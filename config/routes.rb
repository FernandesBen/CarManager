Rails.application.routes.draw do
  root 'home#index'
  get 'new' => 'home#new'
  post 'create' => 'home#create'
  delete 'delete/:id' => 'home#delete'
  get 'update/:id' => 'home#update'
  put 'update/:id' => 'home#save'
  
  namespace 'api' do
    namespace 'v1' do
      get 'cars' => 'cars#index'
      post 'cars' => 'cars#create'
      get 'cars/:id' => 'cars#show'
      delete 'cars/:id' => 'cars#destroy'
      put 'cars/:id' => 'cars#update'
    end
  end
end
