class AddBoundingBoxToVisualizations < ActiveRecord::Migration[8.0]
  def change
    add_column(:visualizations, :bounding_box, :geometry, geographic: true, srid: 4326, type: "polygon")
    add_index(:visualizations, :bounding_box, using: :gist)
  end
end
