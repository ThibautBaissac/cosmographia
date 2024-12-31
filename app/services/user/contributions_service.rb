class User::ContributionsService
  CACHE_EXPIRY = 4.hours

  def initialize(user, range: 365.days.ago.beginning_of_day..Time.current.end_of_day)
    @user = user
    @start_date, @end_date = range.begin, range.end
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
    "user_contributions/#{@user.id}"
  end

  def aggregate_contributions
    date_range = @start_date.to_date..@end_date.to_date

    visualization_counts = @user.visualizations
                                .where(created_at: @start_date..@end_date)
                                .group("DATE(created_at)")
                                .count

    comment_counts = @user.comments
                          .where(created_at: @start_date..@end_date)
                          .group("DATE(created_at)")
                          .count

    discussion_counts = Challenge::Discussion
                           .where(user_id: @user.id, created_at: @start_date..@end_date)
                           .group("DATE(created_at)")
                           .count

    date_range.each_with_object({}) do |date, contributions|
      contributions[date] = (visualization_counts[date] || 0) +
                            (comment_counts[date] || 0) +
                            (discussion_counts[date] || 0)
    end
  end

  def generate_weeks
    start_of_week = @start_date.beginning_of_week(:monday).to_date
    end_of_week = @end_date.end_of_week(:monday).to_date
    all_dates = (start_of_week..end_of_week).to_a
    all_dates.each_slice(7).to_a
  end
end
