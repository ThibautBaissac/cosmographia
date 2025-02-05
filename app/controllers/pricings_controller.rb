class PricingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    plans = Billing::Plan.active
    @active_plan_versions = Billing::ActivePlanVersionsFetcher.new.call
  end
end
