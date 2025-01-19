# frozen_string_literal: true

class TabsNavComponent < ViewComponent::Base
  Tab = Struct.new(:path, :icon_class, :translation_key)

  def initialize(tabs:, turbo_frame: nil)
    @tabs = tabs
    @turbo_frame = turbo_frame
  end

  def active?(path)
    current_page?(path)
  end
end
