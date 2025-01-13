class Billing::Subscription < ApplicationRecord
  self.table_name = "billing_subscriptions"

  belongs_to :user
  belongs_to :plan_version, class_name: "Billing::PlanVersion", foreign_key: :billing_plan_version_id

  validates :billing_cycle_start_date, presence: true
  validates :status, presence: true
  validates :user_id, uniqueness: {scope: :status, conditions: -> { where(status: Billing::Subscription::Active) }, message: "can only have one active subscription"}

  string_enum status: %w[active cancelled trialing expired].freeze

  scope :current, -> { where(status: Billing::Subscription::Active) }
  scope :past, -> { where.not(end_date: nil).where("end_date < ?", Date.today) }


  def free?
    plan_version.price_cents.zero?
  end

  def unlimited_visualizations?
    plan_version.monthly_visualization_limit.nil?
  end


  def monthly_visualization_limit_count
    plan_version.monthly_visualization_limit
  end

  def current_billing_cycle
    today = Time.current.to_date
    months_elapsed = (today.year - billing_cycle_start_date.year) * 12 + (today.month - billing_cycle_start_date.month)
    cycle_start = billing_cycle_start_date.advance(months: months_elapsed)
    cycle_start = cycle_start > today ? cycle_start.advance(months: -1) : cycle_start
    cycle_start
  end

  def current_billing_cycle_end
    current_billing_cycle + 1.month - 1.day
  end

  def needs_billing_cycle_update?
    Time.current.to_date > current_billing_cycle_end
  end

  def update_billing_cycle
    next_cycle_start = billing_cycle_start_date.advance(months: 1)
    update(billing_cycle_start_date: next_cycle_start)
  end

  def remaining_visualizations
    return Float::INFINITY if plan_version.monthly_visualization_limit.nil?

    cycle_start = current_billing_cycle
    cycle_end = current_billing_cycle_end

    # Adjust for cancellation mid-cycle
    effective_end = if status == "CANCELLED" && end_date && end_date < cycle_end
                     end_date
    else
                     cycle_end
    end

    used_visualizations = user.visualizations.where(
      created_at: cycle_start.beginning_of_day..effective_end.end_of_day
    ).count

    plan_version.monthly_visualization_limit - used_visualizations
  end
end
