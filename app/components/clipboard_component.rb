class ClipboardComponent < ViewComponent::Base
  def initialize(text:)
    @text = text
  end
end
