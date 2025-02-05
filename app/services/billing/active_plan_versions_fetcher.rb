class Billing::ActivePlanVersionsFetcher
  def initialize(plans_scope: Billing::Plan.active)
    @plans_scope = plans_scope
  end

  def call
    @plans_scope.map do |plan|
      plan.plan_versions.active.order(version_number: :desc).first
    end.compact
  end
end
