class CreateSources < ActiveRecord::Migration[8.0]
  def change
    create_table(:sources) do |t|
      t.string(:name, null: false)
      t.string(:url, null: false)
      t.string(:location)
      t.string(:description)

      t.timestamps
    end

    add_index(:sources, :name)
    add_index(:location, :description)
    add_index(:sources, :description)
  end
end
