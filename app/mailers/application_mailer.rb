class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:production, :smtp_settings, :user_name) || ENV["GMAIL_USERNAME"]
  layout "mailer"
end
