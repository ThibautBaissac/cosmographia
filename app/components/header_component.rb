class HeaderComponent < ViewComponent::Base
  attr_reader :title, :border

  def initialize(title:, border: true)
    @title = title
    @border = border
  end
end
