class My::SubscriptionController < ApplicationController
  def show
    load_user_subscription_data if current_user.not_guest?
    plans = Billing::Plan.active
    @active_plan_versions = Billing::ActivePlanVersionsFetcher.new.call
  end

  def checkout
    plan_version = Billing::PlanVersion.active.find(params[:plan_version_id])
    authorize(plan_version)
    checkout_session = Billing::CheckoutSessionCreator.new(
      user: current_user,
      plan_version: plan_version,
      stripe_price_id: params[:stripe_price_id]
    ).call
    redirect_to(checkout_session.url, allow_other_host: true, status: :see_other)
  end

  private

  def load_user_subscription_data
    @portal_session = current_user.payment_processor.billing_portal
    @current_subscription = current_user.current_subscription
    @current_plan_version = current_user.current_plan_version
  end
end
