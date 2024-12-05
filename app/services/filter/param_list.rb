class Filter::ParamList
  def initialize(params:)
    @params = params
  end

  def non_empty
    @params.to_h.reject { |_, v| v.blank? || (v.is_a?(Array) && v.all?(&:blank?)) }
  end
end
