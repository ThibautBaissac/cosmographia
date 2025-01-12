class CreateBillingPlans < ActiveRecord::Migration[8.0]
  def change
    create_table(:billing_plans) do |t|
      t.string(:name, null: false)
      t.text(:description)
      t.boolean(:active, default: false, null: false)

      t.timestamps
    end

    add_index(:billing_plans, :active)
  end
end
