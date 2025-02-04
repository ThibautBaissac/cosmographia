module UserContributions
  module ContributionCounters
    class VisualizationsCounter < BaseContributionCounter
      def relation
        user.visualizations
      end
    end
  end
end
