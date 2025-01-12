class Billing::PlanVersion < ApplicationRecord
  self.table_name = 'billing_plan_versions'

  belongs_to :plan, class_name: "Billing::Plan", foreign_key: :billing_plan_id
  has_many :subscriptions, dependent: :restrict_with_error

  validates :version_number, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :price_cents, numericality: {greater_than_or_equal_to: 0}

  scope :active, -> { where(active: true) }
end
