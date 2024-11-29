class CreateMapSoftwares < ActiveRecord::Migration[8.0]
  def change
    create_table(:map_softwares) do |t|
      t.references(:software, null: false, foreign_key: true)
      t.references(:map, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
