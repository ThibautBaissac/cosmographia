class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column(:users, :first_name, :string)
    add_index(:users, :first_name)

    add_column(:users, :last_name, :string)
    add_index(:users, :last_name)

    add_column(:users, :bio, :text)

    add_column(:users, :last_login_at, :datetime)

    add_column(:users, :personal_website, :string)

    add_column(:users, :social_links, :jsonb)

    add_column(:users, :guest, :boolean, default: true)
  end
end
