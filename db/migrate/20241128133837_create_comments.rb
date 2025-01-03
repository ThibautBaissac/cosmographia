class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table(:visualization_comments) do |t|
      t.text(:content, null: false)
      t.references(:visualization, null: false, foreign_key: true)
      t.references(:user, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
