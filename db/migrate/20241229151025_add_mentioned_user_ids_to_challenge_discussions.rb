class AddMentionedUserIdsToChallengeDiscussions < ActiveRecord::Migration[8.0]
  def change
    add_column :challenge_discussions, :mentioned_user_ids, :jsonb, default: []
  end
end
