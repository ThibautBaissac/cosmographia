# frozen_string_literal: true

module User::SubscriptionHandling
  extend ActiveSupport::Concern

  included do
  end

  def current_subscription
    @current_subscription ||= pay_customers&.first&.subscriptions&.active&.last
  end

  def current_plan_version
    @current_plan_version ||=
      Billing::PlanVersion.find_by(id: current_subscription&.metadata&.dig("plan_version_id"))
  end

  def current_plan?(plan_names)
    current_plan = current_plan_version&.plan&.name&.downcase
    normalized_plan_names = Set.new(Array(plan_names).map { |name| name.to_s.downcase })
    normalized_plan_names.include?(current_plan)
  end

  def subscribed?
    @subscribed ||= current_subscription.present?
  end

  def has_remaining_visualizations?
    return false unless subscribed?

    remaining_visualization_count&.positive?
  end

  def has_remaining_challenges?
    return false unless subscribed?

    remaining_challenge_count&.positive?
  end

  def unlimited_visualizations?
    current_plan_version&.monthly_visualization_limit.nil?
  end

  def unlimited_challenges?
    current_plan_version&.monthly_challenge_limit.nil?
  end

  def remaining_visualization_count
    @remaining_visualization_count ||= remaining_count(:monthly_visualization_limit, :visualizations)
  end

  def remaining_challenge_count
    @remaining_challenge_count ||= remaining_count(:monthly_challenge_limit, :challenges)
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

  def remaining_count(limit_attribute, usage_scope)
    return 0 if guest? || !subscribed?

    plan_limit = current_plan_version&.public_send(limit_attribute)
    return Float::INFINITY if plan_limit.nil?

    cycle_start = current_subscription.current_period_start.beginning_of_day
    cycle_end   = current_subscription.current_period_end.end_of_day

    used = public_send(usage_scope).where(created_at: cycle_start..cycle_end).count
    plan_limit - used
  end
end
