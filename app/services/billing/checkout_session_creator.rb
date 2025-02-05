class Billing::CheckoutSessionCreator
  def initialize(user:, plan_version:, stripe_price_id:)
    @user = user
    @plan_version = plan_version
    @stripe_price_id = stripe_price_id
  end

  def call
    @user.payment_processor.checkout(
      mode: "subscription",
      locale: I18n.locale,
      line_items: [{
        price: @stripe_price_id,
        quantity: 1
      }],
      subscription_data: {
        metadata: {
          plan_name: @plan_version.plan.name,
          plan_version_id: @plan_version.id
        }
      },
      success_url: Rails.application.routes.url_helpers.my_subscription_url(host: ENV["HOST"], locale: I18n.locale),
      cancel_url: Rails.application.routes.url_helpers.my_subscription_url(host: ENV["HOST"], locale: I18n.locale)
    )
  end
end
