module UserContributions
  module ContributionCounters
    class CommentsCounter < BaseContributionCounter
      def relation
        user.comments
      end
    end
  end
end
