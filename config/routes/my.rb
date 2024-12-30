namespace :my do
  resource :profile, controller: :profile, only: %i[edit update]
  resources :mentions, only: %i[index]
  resource :info, only: %i[show], controller: :info
  resource :charts, only: %i[show]
  resource :comments, only: %i[show]
end
