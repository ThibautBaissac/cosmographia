namespace :my do
  resource :profile, controller: :profile, only: %i[edit update]
  namespace :profile do
    get "user_info", to: "tabs#user_info"
    get "charts", to: "tabs#charts"
    get "comments", to: "tabs#comments"
  end
end
