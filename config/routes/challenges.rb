resources :challenges do
  resources :visualizations, only: [ :new, :create ]
  resource :user_participation, only: [ :create, :destroy ], module: :challenges, controller: :user_participation
  resource :attach_visualization, only: [ :new, :create ], module: :challenges, controller: :attach_visualization
end
