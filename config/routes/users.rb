patch "update_user_locale", to: "user/locale#update"
get "/:slug", to: "users#show", as: :user_profile, constraints: lambda { |req|
  !I18n.available_locales.include?(req.params[:slug]&.to_sym)
}
