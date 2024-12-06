puts("---- Creating guest users...")
(0...@nb_guest_users).each do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'Password123.',
    password_confirmation: 'Password123.',
    locale: I18n.available_locales.sample.to_s,
    created_at: Faker::Date.backward(days: 365 * 10),
    guest: true
  )

  puts("--(#{i + 1}/#{@nb_guest_users}) #{user.email}")
end
puts("----#{@nb_guest_users} guest users created!")
