puts "---- Seeding Pay::Subscription..."

# Fetch all non-guest users
users = User.non_guests

# Cache necessary plan versions
plan_versions = Billing::PlanVersion.active

users.each_with_index do |user, i|
  plan_version = plan_versions.sample

  begin
    puts("--(#{i + 1}/#{users.size}) Subscribing #{user.email} to #{plan_version.plan.name}...")

    user.payment_processor.update_payment_method("pm_card_visa")
    subscription = user.payment_processor.subscribe(
      name: plan_version.plan.name,
      plan: plan_version.stripe_price_id,
      metadata: {
        pay_name: plan_version.plan.name,
        plan_version_id: plan_version.id
      }
    )

    puts("----> Subscription created: ID=#{subscription.id}, Plan=#{plan_version.plan.name}")
  rescue => e
    puts("----> Failed to subscribe #{user.email}: #{e.message}")
  end
end

puts "---- Seeding Pay::Subscription completed. Total Subscriptions: #{Pay::Subscription.count}"
