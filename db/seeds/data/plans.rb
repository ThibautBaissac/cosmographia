# Create Plans
puts "---- Creating plans..."
plans = [
  {name: 'Free', description: 'Basic access with limited features'},
  {name: 'Basic', description: 'Extended access with more features'},
  {name: 'Premium', description: 'All features with priority support'}
]

plans.each do |plan_attrs|
  Billing::Plan.find_or_create_by!(name: plan_attrs[:name]) do |plan|
    plan.description = plan_attrs[:description]
    plan.active = true
  end
end

puts "----Created #{Billing::Plan.count} plans."


# Seed PlanVersions
puts "---- Creating plan versions..."

Billing::Plan.find_each do |plan|
  case plan.name
  when 'Free'
    Billing::PlanVersion.find_or_create_by!(plan: plan, version_number: 1) do |pv|
      pv.price_cents = 0
      pv.currency = 'EUR'
      pv.monthly_visualization_limit = 5
      pv.active = true
    end

  when 'Basic'
    # Version 1
    Billing::PlanVersion.find_or_create_by!(plan: plan, version_number: 1) do |pv|
      pv.price_cents = 1000  # €10.00
      pv.currency = 'EUR'
      pv.monthly_visualization_limit = 50
      pv.active = false  # Old version
    end

    # Version 2
    Billing::PlanVersion.find_or_create_by!(plan: plan, version_number: 2) do |pv|
      pv.price_cents = 1200  # €12.00
      pv.currency = 'EUR'
      pv.monthly_visualization_limit = 100
      pv.active = true  # Current version
    end

  when 'Premium'
    # Version 1
    Billing::PlanVersion.find_or_create_by!(plan: plan, version_number: 1) do |pv|
      pv.price_cents = 2000  # €20.00
      pv.currency = 'EUR'
      pv.monthly_visualization_limit = 250
      pv.active = false
    end

    # Version 2 (optional)
    Billing::PlanVersion.find_or_create_by!(plan: plan, version_number: 2) do |pv|
      pv.price_cents = 2200  # €22.00
      pv.currency = 'EUR'
      pv.monthly_visualization_limit = nil
      pv.active = true
    end
  end
end
puts "----Created #{Billing::PlanVersion.count} plan versions."
