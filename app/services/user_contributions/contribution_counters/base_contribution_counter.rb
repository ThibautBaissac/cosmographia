module UserContributions
  module ContributionCounters
    class BaseContributionCounter
      attr_reader :user, :start_date, :end_date

      def initialize(user, start_date, end_date)
        @user = user
        @start_date = start_date
        @end_date = end_date
      end

      def counts
        relation
          .where(created_at: start_date..end_date)
          .group("DATE(created_at)")
          .count
          .transform_keys(&:to_date)
      end

      def relation
        raise NotImplementedError, "Subclasses must implement a `relation` method and return an ActiveRecord::Relation"
      end
    end
  end
end
