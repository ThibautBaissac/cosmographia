(0..@nb_users).each do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'Password123.',
    password_confirmation: 'Password123.',
    superadmin: i == 0
  )
  puts("--(#{i + 1}/#{@nb_users}) #{user.email}")
end
puts("----#{@nb_users} users created!")
