class Billing::PlanVersion < ApplicationRecord
  self.table_name = "billing_plan_versions"

  belongs_to :plan, class_name: "Billing::Plan", foreign_key: :billing_plan_id

  validates :version_number, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :version_number, uniqueness: {scope: :billing_plan_id}
  validates :price_cents, numericality: {greater_than_or_equal_to: 0}
  validates :monthly_visualization_limit, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :stripe_price_id, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  before_save :ensure_single_active_version, if: :active_changed?

  def unlimited_visualizations?
    monthly_visualization_limit.nil?
  end

  private

  def ensure_single_active_version
    if active?
      Billing::PlanVersion.where(billing_plan_id: billing_plan_id, active: true).where.not(id: id).update_all(active: false)
    end
  end
end
