namespace :admin do
  resources :feedbacks, only: [ :index ]

  resources :users, only: [:index] do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end
end
