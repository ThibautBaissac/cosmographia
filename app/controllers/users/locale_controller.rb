class Users::LocaleController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    if params[:new_locale].in?(I18n.available_locales.map(&:to_s))
      current_user&.update(locale: params[:new_locale])
      I18n.locale = params[:new_locale]
      session[:locale] = I18n.locale
      redirect_back_or_to_with_locale(root_path(locale))
    else
      redirect_to(root_path(locale), alert: "Invalid locale or user.")
    end
  end

  private

  def redirect_back_or_to_with_locale(default, **options)
    redirect_to(request.referer.present? ? url_with_locale_in_path(request.referer) : url_with_locale_in_path(default),
                **options)
  end

  def url_with_locale_in_path(url)
    uri = URI.parse(url)
    path_segments = uri.path.split("/")

    # Insert or update the locale in the path
    path_segments[1] = I18n.locale.to_s if I18n.available_locales.map(&:to_s).include?(path_segments[1])
    path_segments.insert(1, I18n.locale.to_s) unless I18n.available_locales.map(&:to_s).include?(path_segments[1])

    # Update the path with the correct locale
    uri.path = path_segments.join("/")

    # Remove any conflicting locale query parameters
    query_params = URI.decode_www_form(uri.query.to_s).reject { |k, _| k == "locale" }
    uri.query = URI.encode_www_form(query_params) if query_params.any?

    uri.to_s
  end
end
