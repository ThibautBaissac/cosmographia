class User::LocaleController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    new_locale = params[:new_locale]

    if valid_locale?(new_locale)
      User::LocaleUpdater.new(current_user, new_locale, session).call

      target_url = request.referer.presence || root_path
      redirect_to(User::UrlLocaleBuilder.new(target_url, I18n.locale).build)
    else
      redirect_to(root_path(locale: I18n.locale), alert: "Invalid locale or user.")
    end
  end

  private

  def valid_locale?(locale)
    Constants::Locales::SUPPORTED_LOCALES.include?(locale)
  end
end
