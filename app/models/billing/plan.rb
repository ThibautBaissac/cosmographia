class Billing::Plan < ApplicationRecord
  self.table_name = "billing_plans"
  has_many :plan_versions, dependent: :restrict_with_error, class_name: "Billing::PlanVersion", foreign_key: :billing_plan_id

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  scope :active, -> { where(active: true) }
end
