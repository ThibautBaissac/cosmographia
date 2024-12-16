module Challenge::Status
  extend ActiveSupport::Concern

  included do
    STATUSES = {
      upcoming: ->(challenge) { challenge.start_date > Date.current },
      ongoing: ->(challenge) { challenge.start_date <= Date.current && challenge.end_date >= Date.current },
      ended: ->(challenge) { challenge.end_date < Date.current }
    }

    # Define upcoming?, ongoing?, ended? methods
    STATUSES.each do |status, condition|
      define_method("#{status}?") do
        condition.call(self)
      end
    end

    # Instance method to get the status of the challenge
    def status
      STATUSES.keys.find { |status| send("#{status}?") }
    end

    # Scopes
    STATUSES.each do |status, _|
      scope status, -> {
        case status
        when :upcoming
          where("start_date > ?", Date.current)
        when :ongoing
          where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
        when :ended
          where("end_date < ?", Date.current)
        end
      }
    end
  end
end
