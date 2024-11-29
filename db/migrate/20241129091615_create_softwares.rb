class CreateSoftwares < ActiveRecord::Migration[8.0]
  def change
    create_table(:softwares) do |t|
      t.string(:name, null: false)
      t.string(:category, null: false)
      t.timestamps
    end
  end
end
