class PricingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    plans = Billing::Plan.active
    @active_plan_versions = plans.map { |plan| plan.plan_versions
                                                   .active
                                                   .order(version_number: :desc)
                                                   .first }
  end
end
