resources :challenges, except: [ :show ] do
  resources :visualizations, only: [ :new, :create ]
  resource :user_participation, only: [ :create, :destroy ], module: :challenges, controller: :user_participation
  resource :attach_visualization, only: [ :new, :create ], module: :challenges, controller: :attach_visualization
  member do
    get 'participations', to: 'challenges/tabs#participations'
    get 'discussion', to: 'challenges/tabs#discussion'
  end
end
