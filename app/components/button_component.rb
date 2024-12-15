# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  COLORS = %i[primary secondary success danger warning info light dark link].freeze
  SIZES = %i[sm lg].freeze
  ICON_POSITIONS = %i[left right].freeze

  attr_reader :text, :size, :color, :outline, :rounded, :icon, :icon_position, :html_attributes

  def initialize(
    text: nil,
    color: :primary,
    size: nil,
    outline: false,
    rounded: 4,
    icon: nil,
    icon_position: :left,
    **html_attributes
  )
    @text = text
    @color = fetch_color(color)
    @size = fetch_size(size)
    @outline = outline
    @rounded = fetch_rounded(rounded)
    @icon = icon
    @icon_position = fetch_icon_position(icon_position)
    @html_attributes = html_attributes
  end

  def call
    tag.button(class: button_classes, **html_attributes) do
    if content.present?
      content
    else
      content_array = []
      content_array << icon_tag if icon && icon_position == :left
      content_array << tag.span(text)
      content_array << icon_tag if icon && icon_position == :right
      safe_join(content_array, " ")
    end
    end
  end

  private

  def fetch_color(color)
    COLORS.include?(color) ? color : :primary
  end

  def fetch_size(size)
    SIZES.include?(size) ? size : nil
  end

  def fetch_rounded(rounded)
    rounded.is_a?(Integer) ? rounded : 4
  end

  def fetch_icon_position(position)
    ICON_POSITIONS.include?(position) ? position : :left
  end

  def button_classes
    classes = [ "btn" ]
    classes << "btn-outline-#{color}" if outline
    classes << "btn-#{color}" unless outline
    classes << "btn-#{size}" if size
    classes << "rounded-#{rounded}"
    classes << "d-flex align-items-center gap-2"
    classes << html_attributes[:class] if html_attributes[:class].present?
    classes.join(" ")
  end

  def icon_tag
    tag.i(class: icon)
  end
end
