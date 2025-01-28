class AlertComponent < ViewComponent::Base
  TYPES = %i[primary secondary success danger warning info light dark].freeze

  def initialize(type:, dismissible: false, rounded: 4, extra_classes: nil)
    @type = fetch_type(type)
    @dismissible = dismissible
    @rounded = rounded
    @extra_classes = extra_classes
  end

  private

  def fetch_type(type)
    TYPES.include?(type) ? type : :info
  end
end
