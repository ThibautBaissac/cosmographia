class Visualizations::ColumnDistributed
  def initialize(column_count:, visualization_count:)
    @column_count = column_count
    @visualization_count = visualization_count
  end

  def call
    visualizations = Visualization.limit(@visualization_count).includes(:image_attachment, :user)
    visualizations.group_by.with_index { |_, index| index % @column_count }.values
  end
end
