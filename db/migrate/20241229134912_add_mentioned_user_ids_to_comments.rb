class AddMentionedUserIdsToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :mentioned_user_ids, :jsonb, default: []
  end
end
