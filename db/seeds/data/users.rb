(0..@nb_users).each do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'Password123.',
    password_confirmation: 'Password123.',
    superadmin: i == 0,
    locale: I18n.available_locales.sample.to_s
  )
  puts("--(#{i + 1}/#{@nb_users}) #{user.email}")
end
puts("----#{@nb_users} users created!")
