(0..@nb_users).each do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'Password123.',
    password_confirmation: 'Password123.',
    superadmin: i == 0,
    locale: I18n.available_locales.sample.to_s,
    created_at: Faker::Date.backward(days: 365 * 10),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Lorem.paragraph(sentence_count: 3),
    last_login_at: Faker::Time.backward(days: 365, period: :evening),
    personal_website: Faker::Internet.url,
    social_links: {
      twitter: Faker::Internet.url(host: "twitter.com"),
      linkedin: Faker::Internet.url(host: "linkedin.com/in"),
      github: Faker::Internet.url(host: "github.com")
    }
  )
  puts("--(#{i + 1}/#{@nb_users}) #{user.email}")
end
puts("----#{@nb_users} users created!")
