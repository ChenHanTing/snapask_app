Rails.application.routes.draw do
  resources :courses
  resources :genres
  get 'pages/index'
  devise_for :members
  devise_for :users
  resources :users, only: %w[index edit update]

  use_doorkeeper

  # 首頁
  root to: 'pages#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ApiRoot => ApiRoot::PREFIX
  # Api UI 文件
  mount GrapeSwaggerRails::Engine => '/swagger'
end
