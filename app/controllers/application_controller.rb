class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import visualizations, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :set_locale
  before_action :update_last_presence_at

  private

  def current_user_locale
    current_user&.locale
  end

  def set_locale
    if params[:locale] && !I18n.available_locales.map(&:to_s).include?(params[:locale])
      redirect_to(url_for(locale: I18n.default_locale)) and return
    end

    I18n.locale = url_locale || current_user_locale || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def url_locale
    params[:locale] if I18n.available_locales.map(&:to_s).include?(params[:locale])
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:alert] = t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)
    redirect_back_or_to(root_path)
  end

  def update_last_presence_at
    return unless current_user

    # TODO: move the following code to a background job
    if current_user.last_presence_at != Date.current
      current_user.update(last_presence_at: Date.current)
    end
  end
end
