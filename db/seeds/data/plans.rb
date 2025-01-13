puts "---- Seeding Billing::Plan..."

plans = [
  {name: 'Free', description: 'Basic access with limited features', active: true},
  {name: 'Basic', description: 'Extended access with more features', active: true},
  {name: 'Premium', description: 'All features with priority support', active: true}
]

plans.each do |plan_attrs|
  plan = Billing::Plan.find_or_initialize_by(name: plan_attrs[:name])
  plan.assign_attributes(plan_attrs)

  if plan.save
    puts "✔️  Created/Updated Plan: #{plan.name}"
  else
    puts "❌  Failed to create/update Plan: #{plan.name} - #{plan.errors.full_messages.join(', ')}"
  end
end

puts "---- Seeding Billing::Plan completed. Total Plans: #{Billing::Plan.count}"

# db/seeds/data/plan_versions.rb

puts "---- Seeding Billing::PlanVersion..."

# Cache plans to minimize database queries
plans = Billing::Plan.all.index_by(&:name)

plan_versions_data = {
  'Free' => [
    {
      version_number: 1,
      price_cents: 0,
      currency: 'EUR',
      monthly_visualization_limit: 5,
      active: true
    }
  ],
  'Basic' => [
    {
      version_number: 1,
      price_cents: 1000,  # €10.00
      currency: 'EUR',
      monthly_visualization_limit: 50,
      active: false
    },
    {
      version_number: 2,
      price_cents: 1200,  # €12.00
      currency: 'EUR',
      monthly_visualization_limit: 100,
      active: true
    }
  ],
  'Premium' => [
    {
      version_number: 1,
      price_cents: 2000,  # €20.00
      currency: 'EUR',
      monthly_visualization_limit: 250,
      active: false
    },
    {
      version_number: 2,
      price_cents: 2200,  # €22.00
      currency: 'EUR',
      monthly_visualization_limit: nil,  # Unlimited
      active: true
    }
  ]
}

plan_versions_data.each do |plan_name, versions|
  plan = plans[plan_name]

  unless plan
    puts "❌  Plan not found: #{plan_name}. Skipping its PlanVersions."
    next
  end

  versions.each do |version_attrs|
    plan_version = Billing::PlanVersion.find_or_initialize_by(
      plan: plan,
      version_number: version_attrs[:version_number]
    )
    plan_version.assign_attributes(version_attrs)

    if plan_version.save
      status = plan_version.active? ? 'Active' : 'Inactive'
      puts "✔️  Created/Updated PlanVersion: #{plan.name} v#{plan_version.version_number} (#{status})"
    else
      puts "❌  Failed to create/update PlanVersion for #{plan.name} v#{plan_version.version_number} - #{plan_version.errors.full_messages.join(', ')}"
    end
  end
end

puts "---- Seeding Billing::PlanVersion completed. Total PlanVersions: #{Billing::PlanVersion.count}"
