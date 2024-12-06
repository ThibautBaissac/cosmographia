namespace :my do
  resource :profile, controller: :profile, only: %i[show edit update]
end
