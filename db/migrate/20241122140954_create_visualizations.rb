class CreateVisualizations < ActiveRecord::Migration[8.0]
  def change
    create_table(:visualizations) do |t|
      t.references(:user, null: false, foreign_key: true)
      t.string(:title, null: false)
      t.text(:description)
      t.date(:creation_date)
      t.integer(:scale)
      t.text(:sources)
      t.string(:geographic_coverage)
      t.string(:projection)
      t.boolean(:is_public, default: false)
      t.string(:category, null: false)

      t.timestamps
    end

    add_index(:visualizations, :title)
    add_index(:visualizations, :description)
    add_index(:visualizations, :creation_date)
    add_index(:visualizations, :scale)
    add_index(:visualizations, :sources)
    add_index(:visualizations, :geographic_coverage)
    add_index(:visualizations, :projection)
    add_index(:visualizations, :category)
  end
end
