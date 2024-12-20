module TimeAgoHelper
  DEFAULT_THRESHOLD = 5.days

  def humanized_time_ago(date, threshold: DEFAULT_THRESHOLD)
    return "" if date.nil?

    Time.current - date < threshold ? time_ago_in_words(date) : l(date, format: :dmy)
  end
end
