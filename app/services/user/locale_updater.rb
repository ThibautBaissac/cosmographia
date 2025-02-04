class User::LocaleUpdater
  def initialize(user, new_locale, session)
    @user      = user
    @new_locale = new_locale.to_s
    @session   = session
  end

  def call
    update_user_locale if @user.present?
    I18n.locale = @new_locale
    @session[:locale] = I18n.locale
  end

  private

  def update_user_locale
    @user.update(locale: @new_locale)
  end
end
