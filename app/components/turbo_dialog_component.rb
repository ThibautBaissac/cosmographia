# frozen_string_literal: true

class TurboDialogComponent < ViewComponent::Base
  attr_reader :title
  include Turbo::FramesHelper

  def initialize(title:)
    @title = title
  end
end
