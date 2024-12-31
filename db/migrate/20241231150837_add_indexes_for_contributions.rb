class AddIndexesForContributions < ActiveRecord::Migration[8.0]
  def change
    add_index :visualizations, [:user_id, :created_at], name: 'index_visualizations_on_user_id_and_created_at'
    add_index :visualization_comments, [:user_id, :created_at], name: 'index_visualization_comments_on_user_id_and_created_at'
    add_index :challenge_discussions, [:user_id, :created_at], name: 'index_challenge_discussions_on_user_id_and_created_at'
  end
end
