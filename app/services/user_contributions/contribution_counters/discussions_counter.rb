module UserContributions
  module ContributionCounters
    class DiscussionsCounter < BaseContributionCounter
      def relation
        Challenge::Discussion.where(user_id: user.id)
      end
    end
  end
end
