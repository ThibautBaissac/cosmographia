class AddMentionedUserIdsToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :mentioned_user_ids, :jsonb, default: []
    add_index :comments, :mentioned_user_ids, using: :gin
  end
end
