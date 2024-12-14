class HeaderComponent < ViewComponent::Base
  attr_reader :title, :button

  def initialize(title:, button: nil)
    @title = title
    @button = button
  end

  def button?
    button.present?
  end
end
