class Billing::Plan < ApplicationRecord
  self.table_name = "billing_plans"
  has_many :plan_versions, dependent: :destroy, class_name: "Billing::PlanVersion", foreign_key: :billing_plan_id

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
end
