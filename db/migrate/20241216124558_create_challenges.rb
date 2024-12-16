class CreateChallenges < ActiveRecord::Migration[8.0]
  def change
    create_table(:challenges) do |t|
      t.string(:title, null: false)
      t.text(:description, null: false)
      t.date(:start_date)
      t.date(:end_date, null: false)
      t.string(:difficulty, null: false)
      t.string(:category)

      t.timestamps
    end

    add_index(:challenges, :start_date)
    add_index(:challenges, :end_date)
    add_index(:challenges, :difficulty)
    add_index(:challenges, :category)
  end
end
