ClioInOutStub::Application.routes.draw do

  devise_for :users

  resources :users, :only => [:index, :show, :edit, :update] do
    member do
      get :status
      put :boot
      put :add
    end
  end
  resources :teams, :only => [:new, :create, :edit, :destroy, :update]

  get '/statuses' => "users#statuses"

  root :to => "users#index"

  match "users/:id/boot" => "users#boot", :via => :post
  match "users/:id/add" => "users#add", :via => :post

end
