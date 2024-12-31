class My::ContributionsController < ApplicationController
  before_action :set_user

  def show
    @start_date = 365.days.ago.beginning_of_day
    @end_date = Time.current.end_of_day

    cache_key = "user_contributions/#{@user.id}"
      @contributions_by_day = Rails.cache.fetch(cache_key, expires_in: 4.hours) do
      aggregate_contributions(@start_date, @end_date)
    end

    @weeks = prepare_weeks(@start_date, @end_date)
  end

  private

  def set_user
    @user = current_user
  end

  def aggregate_contributions(start_date, end_date)
    visualization_counts = @user.visualizations
                              .where(created_at: start_date..end_date)
                              .group("DATE_TRUNC('day', created_at)")
                              .count

                              comment_counts = @user.comments
                         .where(created_at: start_date..end_date)
                         .group("DATE_TRUNC('day', created_at)")
                         .count

    discussion_counts = Challenge::Discussion
                          .where(user_id: @user.id, created_at: start_date..end_date)
                          .group("DATE_TRUNC('day', created_at)")
                          .count

    # Combine the counts
    all_dates = (start_date.to_date..end_date.to_date).to_a
    contributions_by_day = {}

    # Normalize keys to Date objects
    visualization_counts = visualization_counts.transform_keys { |datetime| datetime.strftime("%y%m%d") }
    comment_counts = comment_counts.transform_keys { |datetime| datetime.strftime("%y%m%d") }
    discussion_counts = discussion_counts.transform_keys { |datetime| datetime.strftime("%y%m%d") }

    all_dates.each do |date|
      vis_count  = visualization_counts[date.strftime("%y%m%d")]  || 0
      comm_count = comment_counts[date.strftime("%y%m%d")]        || 0
      disc_count = discussion_counts[date.strftime("%y%m%d")]     || 0
      contributions_by_day[date.strftime("%y%m%d")] = vis_count + comm_count + disc_count
    end
    contributions_by_day
  end

  def prepare_weeks(start_date, end_date)
    start_date = start_date.beginning_of_week(:monday)
    end_date = end_date.end_of_week(:monday)

    weeks = []
    current_week = []
    current_date = start_date

    while current_date <= end_date
      7.times do
        current_week << current_date
        current_date += 1.day
      end
      weeks << current_week
      current_week = []
    end

    weeks
  end
end
