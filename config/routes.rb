Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount MissionControl::Jobs::Engine, at: "/jobs"
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/ do
    get "manifest" => "rails/pwa#manifest", as: :pwa_manifest # keep this route above the users routes to avoid conflicts between /user#slug and /manifest
    # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

    devise_for :users
    root "home#index"

    draw :admin
    draw :challenges
    draw :community
    draw :feedbacks
    draw :visualizations
    draw :mentions
    draw :my
    draw :pricings
    draw :static_pages
    draw :sources

    # Do not add routes below :users, it will override the user#slug route
    draw :users
  end
end
