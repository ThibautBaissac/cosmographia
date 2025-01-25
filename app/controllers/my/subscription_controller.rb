class My::SubscriptionController < ApplicationController
  def show
    load_user_subscription_data if current_user.not_guest?
    plans = Billing::Plan.active
    @active_plan_versions = plans.map { |plan| plan.plan_versions.active.order(version_number: :desc).first }
  end

  def checkout
    @plan_version = Billing::PlanVersion.active.find(params[:plan_version_id])
    authorize(@plan_version)
    @checkout_session = create_checkout_session
    redirect_to(@checkout_session.url, allow_other_host: true, status: :see_other)
  end

  private

  def load_user_subscription_data
    @portal_session = current_user.payment_processor.billing_portal
    @current_subscription = current_user.current_subscription
    @current_plan_version = current_user.current_plan_version
  end

  def create_checkout_session
    current_user.payment_processor.checkout(
      mode: "subscription",
      locale: I18n.locale,
      line_items: [ {
        price: params[:stripe_price_id],
        quantity: 1
      } ],
      subscription_data: {
        metadata: {
          plan_name: @plan_version.plan.name,
          plan_version_id: @plan_version.id
        }
      },
      success_url: my_subscription_url(locale),
      cancel_url: my_subscription_url(locale)
    )
  end
end
