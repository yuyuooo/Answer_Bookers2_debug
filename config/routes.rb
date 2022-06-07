Rails.application.routes.draw do

  get '/search', to: 'searches#search_result'

  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]

  get 'relationships/followings'
  get 'relationships/followers'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update]  do
    resource :relationships, only:[:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :notifications, only: [:index] do
    collection do 
      delete 'destroy_all'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
