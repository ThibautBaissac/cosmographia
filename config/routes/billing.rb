namespace :billing do
  resources :subscriptions, only: [ :index, :show, :new, :create, :destroy ]
end
