class Maps::ColumnDistributed
  def initialize(column_count:, map_count:)
    @column_count = column_count
    @map_count = map_count
  end

  def call
    maps = Map.limit(@map_count).includes(:image_attachment, :user)
    maps.group_by.with_index { |_, index| index % @column_count }.values
  end
end
