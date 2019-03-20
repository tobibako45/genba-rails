Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # admin
  namespace :admin do
    resources :users
  end

  root to: 'tasks#index'

  resources :tasks do
    # 新規登録の確認画面 /tasks/new/confirm というURLをconfirm_newアクションに対応させる
    post :confirm, action: :confirm_new, on: :new
    # importアクションを追加する
    post :import, on: :collection
  end

end
