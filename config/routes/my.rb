namespace :my do
  resource :profile, controller: :profile, only: %i[edit update]
  namespace :profile do
    get "info", to: "tabs#info"
    get "charts", to: "tabs#charts"
    get "comments", to: "tabs#comments"
  end
end
