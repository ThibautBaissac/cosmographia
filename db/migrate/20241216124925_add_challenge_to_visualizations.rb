class AddChallengeToVisualizations < ActiveRecord::Migration[8.0]
  def change
    add_reference(:visualizations, :challenge, foreign_key: true)
  end
end
