# frozen_string_literal: true

class ContributionsGraphComponent < ViewComponent::Base
  def initialize(weeks:, contributions_by_day:)
    @weeks = weeks
    @contributions_by_day = contributions_by_day
  end
end
