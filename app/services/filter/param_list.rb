class Filter::ParamList
  def initialize(params:)
    @params = params.to_h.freeze
  end

  def non_empty
    filter_blank_values(@params)
  end

  private

  def filter_blank_values(params)
    params.reject { |_, v| blank_value?(v) }
  end

  def blank_value?(value)
    value.blank? || (value.is_a?(Array) && value.all?(&:blank?))
  end
end
