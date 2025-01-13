# db/seeds/data/subscriptions.rb

puts "---- Seeding Billing::Subscription..."

# Fetch all non-guest users
users = User.non_guests.to_a
total_users = users.size

# Cache necessary plan versions
plan_versions = {
  free: Billing::Plan.find_by(name: 'Free')&.plan_versions&.find_by(version_number: 1),
  basic_v1: Billing::Plan.find_by(name: 'Basic')&.plan_versions&.find_by(version_number: 1),
  basic_v2: Billing::Plan.find_by(name: 'Basic')&.plan_versions&.find_by(version_number: 2),
  premium_v1: Billing::Plan.find_by(name: 'Premium')&.plan_versions&.find_by(version_number: 1),
  premium_v2: Billing::Plan.find_by(name: 'Premium')&.plan_versions&.find_by(version_number: 2)
}

# Ensure all necessary plan versions are present
missing_versions = plan_versions.select { |_, v| v.nil? }.keys
unless missing_versions.empty?
  puts "❌  Missing PlanVersions: #{missing_versions.map(&:to_s).join(', ')}. Aborting subscription seeding."
  exit 1
end

# Helper methods for creating subscriptions
def create_subscription!(attributes)
  subscription = Billing::Subscription.find_or_initialize_by(
    user: attributes[:user],
    plan_version: attributes[:plan_version],
    status: attributes[:status]
  )
  subscription.assign_attributes(attributes.except(:user, :plan_version, :status))

  if subscription.save
    puts("✔️  Created/Updated Subscription: User #{subscription.user.id}, Plan #{subscription.plan_version.plan.name} v#{subscription.plan_version.version_number}, Status: #{subscription.status.capitalize}")
  else
    puts("❌  Failed to create/update Subscription for User #{subscription.user.id} - #{subscription.errors.full_messages.join(', ')}")
  end
end

users.each_with_index do |user, index|
  case index
  when 0..4
    # Users on Free plan
    create_subscription!(
      user: user,
      plan_version: plan_versions[:free],
      status: 'ACTIVE',
      external_subscription_id: nil,
      external_customer_id: nil,
      created_at: 3.months.ago
    )

  when 5..14
    # Users on Basic plan (current version)
    create_subscription!(
      user: user,
      plan_version: plan_versions[:basic_v2],
      status: 'ACTIVE',
      external_subscription_id: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
      external_customer_id: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
      created_at: 3.months.ago
    )

    # Add a past subscription to Basic v1 with 70% probability
    if rand < 0.7
      create_subscription!(
        user: user,
        plan_version: plan_versions[:basic_v1],
        status: 'EXPIRED',
        end_date: Faker::Date.between(from: 1.month.ago, to: 6.month.ago),
        external_subscription_id: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
        external_customer_id: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
        created_at: 4.years.ago
        )
    end

  else
    # Users on Premium plan
    create_subscription!(
      user: user,
      plan_version: plan_versions[:premium_v2],
      status: 'ACTIVE',
      external_subscription_id: Faker::Alphanumeric.alphanumeric(number: 12).upcase,
      external_customer_id: Faker::Alphanumeric.alphanumeric(number: 12).upcase,
      created_at: 3.months.ago
    )

    # Optionally, add a trial subscription with 50% probability
    if rand < 0.5
      create_subscription!(
        user: user,
        plan_version: plan_versions[:free],
        status: 'CANCELLED',
        end_date: Faker::Date.between(from: 1.month.ago, to: 6.month.ago),
        external_subscription_id: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
        external_customer_id: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
        created_at: 1.year.ago
      )
    end
  end
end

puts "---- Seeding Billing::Subscription completed. Total Subscriptions: #{Billing::Subscription.count}"
