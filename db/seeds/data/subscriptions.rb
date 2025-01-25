puts "---- Seeding Pay::Subscription..."

# Fetch all non-guest users
users = User.non_guests
total_users = users.size

# Cache necessary plan versions
plan_versions = Billing::PlanVersion.active
total_plans = plan_versions.size

# Calculate the base number of users per plan and remaining users that couldn't be evenly distributed
users_per_plan = total_users / total_plans
remaining_users = total_users % total_plans
current_index = 0

plan_versions.each_with_index do |plan_version, index|
  number_of_users = index == total_plans - 1 ? (users_per_plan + remaining_users) : users_per_plan
  users_subset = users[current_index, number_of_users]

  users_subset.each do |user|
    user.payment_processor.update_payment_method("pm_card_visa")

    subscription = user.payment_processor.subscribe(
      name: plan_version.plan.name,
      plan: plan_version.stripe_price_id,
      metadata: {
        plan_name: plan_version.plan.name,
        plan_version_id: plan_version.id
      }
    )

    puts("----> Subscription created: ID=#{subscription.id}, Plan=#{plan_version.plan.name}")
  end

  # Move to the next subset of users
  current_index += number_of_users
end

puts "---- Seeding Pay::Subscription completed. Total Subscriptions: #{Pay::Subscription.count}"
