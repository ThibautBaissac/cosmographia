class CreateChallengesDiscussions < ActiveRecord::Migration[8.0]
  def change
    create_table :challenge_discussions do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
