resources :visualizations, only: [ :index, :show, :new, :create, :edit, :update ] do
  resources :comments, only: [ :new, :create, :edit, :update, :destroy ], module: :visualizations
end
