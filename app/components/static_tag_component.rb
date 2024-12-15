# frozen_string_literal: true

class StaticTagComponent < ViewComponent::Base
  COLORS = %i[primary secondary success danger warning info light dark link].freeze

  attr_reader :text, :color, :size

  def initialize(text: nil, color: :primary)
    @text = text
    @color = fetch_color(color)
  end

  def call
    tag.span(class: span_classes) do
      content.present? ? content : text
    end
  end

  private

  def fetch_color(color)
    COLORS.include?(color) ? color : :primary
  end


  def span_classes
    classes = [ "badge" ]
    classes << "text-bg-#{color}"
    classes.join(" ")
  end
end
