class CreateVisualizationSoftwares < ActiveRecord::Migration[8.0]
  def change
    create_table(:visualization_softwares) do |t|
      t.references(:software, null: false, foreign_key: true)
      t.references(:visualization, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
