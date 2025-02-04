class UserContributions::ContributionsService
  CACHE_EXPIRY = 4.hours

  attr_reader :user, :start_date, :end_date

  def initialize(user, range: 365.days.ago.beginning_of_day..Time.current.end_of_day)
    @user = user
    @start_date = range.begin
    @end_date = range.end
  end

  def contributions_by_day
    Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRY) do
      aggregate_contributions
    end
  end

  def weeks
    generate_weeks
  end

  private

  def cache_key
    "user_contributions/#{user.id}/#{start_date.to_i}-#{end_date.to_i}"
  end

  def aggregate_contributions
    date_range = start_date.to_date..end_date.to_date
    contributions = date_range.each_with_object({}) { |date, hash| hash[date] = 0 }

    contribution_counters.each do |counter|
      counter.counts.each do |date, count|
        contributions[date] += count
      end
    end

    contributions
  end

  def contribution_counters
    @contribution_counters ||= [
      UserContributions::ContributionCounters::VisualizationsCounter.new(user, start_date, end_date),
      UserContributions::ContributionCounters::CommentsCounter.new(user, start_date, end_date),
      UserContributions::ContributionCounters::DiscussionsCounter.new(user, start_date, end_date)
    ]
  end

  def generate_weeks
    start_of_week = start_date.beginning_of_week(:monday).to_date
    end_of_week   = end_date.end_of_week(:monday).to_date
    (start_of_week..end_of_week).to_a.each_slice(7).to_a
  end
end
