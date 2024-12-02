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
      t.boolean(:is_public, default: false)

      t.timestamps
    end

    add_index(:maps, :title)
    add_index(:maps, :description)
    add_index(:maps, :creation_date)
    add_index(:maps, :scale)
    add_index(:maps, :sources)
    add_index(:maps, :geographic_coverage)
    add_index(:maps, :projection)
  end
end
