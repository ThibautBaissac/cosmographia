resources :challenges do
  member do
    post "join"
    delete "leave"
  end

  resources :visualizations, only: [ :new, :create ]
end
