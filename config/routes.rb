Rails.application.routes.draw do
  resources :courses
  resources :genres
  get 'pages/index'
  devise_for :members
  devise_for :users

  # 首頁
  root to: 'pages#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
