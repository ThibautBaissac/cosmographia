resources :challenges do
  resource :user_participation, only: [ :create, :destroy ], module: :challenges, controller: :user_participation

  resources :visualizations, only: [ :new, :create ]
end
