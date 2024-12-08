class AddAttributesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column(:users, :superadmin, :boolean, default: false)
    add_column(:users, :locale, :string, null: false, default: "en")
  end
end
