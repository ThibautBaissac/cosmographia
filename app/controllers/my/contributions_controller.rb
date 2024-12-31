class My::ContributionsController < ApplicationController
  before_action :set_user

  def show
    @start_date = 365.days.ago.beginning_of_day
    @end_date = Time.current.end_of_day

    @contributions_by_day = fetch_contributions(@start_date, @end_date)
    @weeks = generate_weeks(@start_date, @end_date)
  end

  private

  def set_user
    @user = current_user
  end

  def fetch_contributions(start_date, end_date)
    cache_key = "user_contributions/#{@user.id}"
    Rails.cache.fetch(cache_key, expires_in: 4.hours) do
      aggregate_contributions(start_date, end_date)
    end
  end

  def aggregate_contributions(start_date, end_date)
    date_range = start_date.to_date..end_date.to_date

    visualization_counts = @user.visualizations
                               .where(created_at: start_date..end_date)
                               .group("DATE(created_at)")
                               .count

    comment_counts = @user.comments
                          .where(created_at: start_date..end_date)
                          .group("DATE(created_at)")
                          .count

    discussion_counts = Challenge::Discussion
                           .where(user_id: @user.id, created_at: start_date..end_date)
                           .group("DATE(created_at)")
                           .count

    date_range.each_with_object({}) do |date, contributions|
      contributions[date] = (visualization_counts[date] || 0) +
                            (comment_counts[date] || 0) +
                            (discussion_counts[date] || 0)
    end
  end

  def generate_weeks(start_date, end_date)
    start_of_week = start_date.beginning_of_week(:monday).to_date
    end_of_week = end_date.end_of_week(:monday).to_date
    all_dates = (start_of_week..end_of_week).to_a
    all_dates.each_slice(7).to_a
  end
end
