class Billing::Subscription < ApplicationRecord
  self.table_name = 'billing_subscriptions'

  belongs_to :user
  belongs_to :plan_version, class_name: "Billing::PlanVersion", foreign_key: :billing_plan_version_id

  validates :start_date, presence: true
  validates :status, presence: true

  string_enum status: %w[active cancelled trialing expired].freeze

  scope :current, -> { where(status: Billing::Subscription::Active) }
  scope :past, -> { where.not(end_date: nil).where("end_date < ?", Date.today) }


  def active?
    status == Billing::Subscription::Active
  end

  def visualization_limit_count
    plan_version.visualization_limit
  end

  def remaining_visualizations
    visualization_limit_count - user.visualizations.where("created_at >= ?", start_date).count
  end
end
