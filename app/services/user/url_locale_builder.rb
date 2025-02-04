class User::UrlLocaleBuilder
  def initialize(url, locale)
    @url    = url
    @locale = locale.to_s
  end

  def build
    uri = URI.parse(@url)
    uri.path = build_path_with_locale(uri.path)
    uri.query = build_query_without_locale(uri.query)
    uri.to_s
  end

  private

  def build_path_with_locale(path)
    # Split the path keeping in mind that the first segment might be blank (for leading '/')
    segments = path.split('/')

    # The locale is expected to be the first non-empty segment.
    # segments[0] is blank if the path begins with a slash.
    locale_index = segments.first.blank? ? 1 : 0

    if segments[locale_index] && Constants::Locales::SUPPORTED_LOCALES.include?(segments[locale_index])
      segments[locale_index] = @locale
    else
      segments.insert(locale_index, @locale)
    end

    segments.join('/')
  end

  def build_query_without_locale(query)
    return nil if query.blank?

    params = URI.decode_www_form(query)
    filtered_params = params.reject { |key, _| key == "locale" }
    filtered_params.any? ? URI.encode_www_form(filtered_params) : nil
  end
end
