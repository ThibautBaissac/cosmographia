# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  attr_reader :id, :title

  def initialize(id:, title:)
    @id = id
    @title = title
  end
end
