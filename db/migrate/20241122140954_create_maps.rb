class CreateMaps < ActiveRecord::Migration[8.0]
  def change
    create_table(:maps) do |t|
      t.references(:user, null: false, foreign_key: true)
      t.string(:title, null: false)
      t.text(:description)
      t.date(:creation_date)
      t.integer(:scale)
      t.text(:sources)
      t.string(:geographic_coverage)
      t.string(:projection)
      t.string(:coordinate_system)
      t.boolean(:is_public, default: true)

      t.timestamps
    end
  end
end
