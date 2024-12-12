class AddSlugAndPublicProfileToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column(:users, :slug, :string, null: false)
    add_index(:users, :slug, unique: true)

    add_column(:users, :public_profile, :boolean, default: false)
  end
end
