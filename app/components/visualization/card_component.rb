# frozen_string_literal: true

class Visualization::CardComponent < ViewComponent::Base
  attr_reader :visualization

  def initialize(visualization:)
    @visualization = visualization
  end
end
