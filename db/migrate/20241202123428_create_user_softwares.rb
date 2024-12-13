class CreateUserSoftwares < ActiveRecord::Migration[8.0]
  def change
    create_table(:user_softwares) do |t|
      t.references(:software, null: false, foreign_key: true)
      t.references(:user, null: false, foreign_key: true)
      t.integer(:level, default: 1)

      t.timestamps
    end
  end
end
