class AddMentionedUserIdsToChallengeDiscussions < ActiveRecord::Migration[8.0]
  def change
    add_column :challenge_discussions, :mentioned_user_ids, :jsonb, default: []
    add_index :challenge_discussions, :mentioned_user_ids, using: :gin
  end
end
