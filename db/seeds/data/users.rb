(0..@nb_users).each do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    superadmin: i == 0
  )
  puts("--(#{i + 1}/#{@nb_users}) #{user.email}")
end
puts("----#{@nb_users} users created!")
