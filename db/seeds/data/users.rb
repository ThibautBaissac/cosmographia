puts("---- Creating users...")
(0...@nb_users).each do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'Password123.',
    password_confirmation: 'Password123.',
    superadmin: i == 0,
    locale: I18n.available_locales.sample.to_s,
    created_at: Faker::Date.backward(days: 365),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    country_code: ISO3166::Country.all.sample.alpha2,
    public_profile: [ true, false ].sample,
    bio: Faker::Lorem.paragraph(sentence_count: 10, supplemental: true, random_sentences_to_add: 4),
    personal_website: Faker::Internet.url,
    confirmed_at: Time.now,
    social_links: {
      linkedin: Faker::Internet.url(host: "linkedin.com/in"),
      github: Faker::Internet.url(host: "github.com")
    }
  )

  (1..rand(2..5)).each do
    user.user_softwares.create!(
      software_id: Software.pluck(:id).sample,
      expertise: UserSoftware.expertise_values.sample,
    )
  end



  puts("--(#{i + 1}/#{@nb_users}) #{user.email}")
end
puts("----#{@nb_users} users created!")
