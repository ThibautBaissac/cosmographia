class CreateBillingPlanVersions < ActiveRecord::Migration[8.0]
  def change
    create_table(:billing_plan_versions) do |t|
      t.references(:billing_plan, null: false, foreign_key: true)
      t.integer(:price_cents, default: 0, null: false)
      t.string(:currency, default: 'EUR', null: false)
      t.integer(:visualization_limit, default: 0, null: false)
      t.integer(:version_number, null: false)
      t.boolean(:active, default: true, null: false)

      t.timestamps
    end

    add_index(:billing_plan_versions, [ :billing_plan_id, :version_number ], unique: true)
    add_index(:billing_plan_versions, :active)
  end
end
