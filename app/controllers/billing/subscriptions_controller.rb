class Billing::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [ :destroy ]

  def index
    @subscriptions = current_user.subscriptions
                                .includes(plan_version: :plan)
                                .order(Arel.sql("CASE WHEN status = 'ACTIVE' THEN 0 ELSE 1 END, created_at DESC"))
  end

  def show
    @current_subscription = current_user.current_subscription
    if @current_subscription.nil?
      redirect_to(new_billing_subscription_path(locale), notice: "You do not have an active subscription.")
    end
  end

  def new
    @plans = Billing::Plan.where(active: true)
    @latest_plan_versions = @plans.map { |plan| plan.plan_versions.active.order(version_number: :desc).first }
  end

  def create
    @plan_version = Billing::PlanVersion.active.find(params[:plan_version_id])
    unless @plan_version
      redirect_to(new_billing_subscription_path(locale), alert: "Selected plan version is not available.")
      return
    end

    # Optional: Implement payment processing with Stripe or pay-rails here
    # Handle payment success/failure accordingly

    ActiveRecord::Base.transaction do
      if current_user.current_subscription.present?
        current_user.current_subscription.update!(end_date: Date.today - 1, status: Billing::Subscription::Cancelled)
      end

      @subscription = current_user.subscriptions.new(
        plan_version: @plan_version,
        billing_cycle_start_date: Time.current.to_date,
        status: Billing::Subscription::Active
        # external_subscription_id and external_customer_id will be handled during payment integration
      )

      @subscription.save!
    end

    # Optional: Handle payment confirmation and assign external IDs

    redirect_to(billing_subscription_path(locale, current_user.current_subscription), notice: "Subscription successfully created.")
  rescue ActiveRecord::RecordInvalid => e
    @plans = Billing::Plan.active
    @latest_plan_versions = @plans.map { |plan| plan.plan_versions.active.order(version_number: :desc).first }
    flash[:alert] = e.message
    render(:new)
  end

  def destroy
    if @subscription.active?
      @subscription.update(end_date: Date.today - 1, status: Billing::Subscription::Cancelled)
      # Optional: Handle Stripe or pay-rails cancellation here
      current_user.subscriptions.create(
        plan_version: Billing::Plan.active.where(name: 'Free').last,
        billing_cycle_start_date: Time.current.to_date,
        status: Billing::Subscription::Active
      )
      redirect_to(billing_subscriptions_path(locale), notice: "Subscription was successfully canceled.")
    else
      redirect_to(billing_subscriptions_path(locale), alert: "Subscription is not active.")
    end
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to(billing_subscriptions_path(locale), alert: "Subscription not found.")
  end
end
