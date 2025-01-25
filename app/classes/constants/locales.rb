module Constants
  module Locales
    SUPPORTED_LOCALES = I18n.available_locales.map(&:to_s).freeze
  end
end
