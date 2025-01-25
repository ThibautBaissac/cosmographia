# frozen_string_literal: true

module User::SubscriptionHandling
  extend ActiveSupport::Concern

  included do
  end

  def current_subscription
    @current_subscription ||= pay_customers&.first&.subscriptions&.active&.last
  end

  def subscribed?
    @subscribed ||= current_subscription.present?
  end

  def has_remaining_visualizations?
    subscribed? && remaining_visualization_count&.positive?
  end

  def has_remaining_challenges?
    remaining_challenge_count&.positive?
  end

  def unlimited_visualizations?
    current_plan_version&.monthly_visualization_limit.nil?
  end

  def unlimited_challenges?
    current_plan_version&.monthly_challenge_limit.nil?
  end

  def remaining_visualization_count
    return 0 if guest? || !subscribed?
    return Float::INFINITY if current_plan_version&.monthly_visualization_limit.nil?

    cycle_start = current_subscription.current_period_start
    cycle_end   = current_subscription.current_period_end

    used_visualizations = visualizations.where(
      created_at: cycle_start.beginning_of_day..cycle_end.end_of_day
    ).count

    current_plan_version.monthly_visualization_limit - used_visualizations
  end

  def remaining_challenge_count
    return 0 if guest? || !subscribed?
    return Float::INFINITY if current_plan_version&.monthly_challenge_limit.nil?

    cycle_start = current_subscription.current_period_start
    cycle_end   = current_subscription.current_period_end

    used_challenges = challenges.where(
      created_at: cycle_start.beginning_of_day..cycle_end.end_of_day
    ).count

    current_plan_version.monthly_challenge_limit - used_challenges
  end

  def current_plan_version
    @current_plan_version ||=
      Billing::PlanVersion.find_by(id: current_subscription&.metadata&.dig("plan_version_id"))
  end

  def stripe_attributes(pay_customer)
    {
      address: {
        country: pay_customer.owner.country.iso_short_name
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id
      }
    }
  end

  private

  def find_subscription(plan_name)
    payment_processor.subscriptions.find_by(name: plan_name)
  end
end
