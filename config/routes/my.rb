namespace :my do
  resource :profile, controller: :profile, only: %i[show edit update]
  namespace :profile do
    get "tabs/user_info", to: "tabs#user_info"
    get "tabs/charts", to: "tabs#charts"
    get "tabs/visualizations", to: "tabs#visualizations"
    get "tabs/comments", to: "tabs#comments"
  end
end
