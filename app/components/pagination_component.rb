# frozen_string_literal: true

class PaginationComponent < ViewComponent::Base
  attr_reader :pagy

  def initialize(pagy:)
    @pagy = pagy
  end
end
