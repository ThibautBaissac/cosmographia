class CreateBillingSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table(:billing_subscriptions) do |t|
      t.references(:user, null: false, foreign_key: true)
      t.references(:billing_plan_version, null: false, foreign_key: true)
      t.date(:start_date, null: false)
      t.date(:end_date)
      t.string(:status, default: "ACTIVE", null: false)
      t.string(:external_subscription_id)
      t.string(:external_customer_id)

      t.timestamps
    end

    add_index(:billing_subscriptions, :status)
  end
end
