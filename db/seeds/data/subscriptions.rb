puts("---- Creating subscriptions...")
users = User.non_guests

# Define plan versions for ease of access
free_plan_version = Billing::Plan.find_by(name: 'Free').plan_versions.find_by(version_number: 1)
basic_plan_version_v1 = Billing::Plan.find_by(name: 'Basic').plan_versions.find_by(version_number: 1)
basic_plan_version_v2 = Billing::Plan.find_by(name: 'Basic').plan_versions.find_by(version_number: 2)
premium_plan_version_v1 = Billing::Plan.find_by(name: 'Premium').plan_versions.find_by(version_number: 1)
premium_plan_version_v2 = Billing::Plan.find_by(name: 'Premium').plan_versions.find_by(version_number: 2)

users.each_with_index do |user, index|
  case index
  when 0..4
    # Users on Free plan
    Billing::Subscription.find_or_create_by!(user: user, plan_version: free_plan_version) do |sub|
      sub.billing_cycle_start_date = Faker::Date.between(from: 2.years.ago, to: 1.year.ago)
      sub.status = Billing::Subscription::Active
      sub.external_subscription_id = nil
      sub.external_customer_id = nil
      sub.created_at = sub.billing_cycle_start_date - 3.months
    end
  when 5..14
    # Users on Basic plan (current version)
    Billing::Subscription.find_or_create_by!(user: user, plan_version: basic_plan_version_v2) do |sub|
      sub.billing_cycle_start_date = Faker::Date.between(from: 1.year.ago, to: Date.today)
      sub.status = Billing::Subscription::Active
      sub.external_subscription_id = Faker::Alphanumeric.alphanumeric(number: 10).upcase
      sub.external_customer_id = Faker::Alphanumeric.alphanumeric(number: 10).upcase
      sub.created_at = sub.billing_cycle_start_date - 3.months
    end

    # Add a past subscription to Basic v1
    if rand < 0.7 # 70% chance to have a past subscription
      Billing::Subscription.find_or_create_by!(user: user, plan_version: basic_plan_version_v1) do |sub|
        sub.billing_cycle_start_date = Faker::Date.between(from: 3.years.ago, to: 2.years.ago)
        sub.end_date = Faker::Date.between(from: 2.years.ago, to: 1.year.ago)
        sub.status = Billing::Subscription::Expired
        sub.external_subscription_id = Faker::Alphanumeric.alphanumeric(number: 10).upcase
        sub.external_customer_id = Faker::Alphanumeric.alphanumeric(number: 10).upcase
        sub.created_at = sub.billing_cycle_start_date - 3.months
      end
    end
  when 15..users.size
    # Users on Premium plan
    Billing::Subscription.find_or_create_by!(user: user, plan_version: premium_plan_version_v2) do |sub|
      sub.billing_cycle_start_date = Faker::Date.between(from: 6.months.ago, to: Date.today)
      sub.status = Billing::Subscription::Active
      sub.external_subscription_id = Faker::Alphanumeric.alphanumeric(number: 12).upcase
      sub.external_customer_id = Faker::Alphanumeric.alphanumeric(number: 12).upcase
      sub.created_at = sub.billing_cycle_start_date - 3.months
    end

    # Optionally, add a trial subscription
    if rand < 0.5 # 50% chance to have a trial subscription
      Billing::Subscription.create!(
        user: user,
        plan_version: free_plan_version,
        billing_cycle_start_date: Faker::Date.between(from: 1.year.ago, to: 6.months.ago),
        end_date: Faker::Date.between(from: 6.months.ago, to: 5.months.ago),
        status: Billing::Subscription::Cancelled,
        external_subscription_id: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
        external_customer_id: Faker::Alphanumeric.alphanumeric(number: 10).upcase
      )
      Billing::Subscription.last.update(created_at: Billing::Subscription.last.billing_cycle_start_date - 3.months)
    end
  end
end
