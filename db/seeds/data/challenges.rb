puts("---- Creating challenges...")
(0...@nb_challenges).each do |i|
  start_date = Faker::Date.between(from: 1.month.ago, to: 1.month.from_now)
  end_date = Faker::Date.between(from: start_date, to: start_date + 10.days)
  challenge = Challenge.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.sentence(word_count: 10),
    start_date:,
    end_date:,
    difficulty: Challenge.difficulty_values.sample,
    category: Challenge.category_values.sample
  )

  (0..rand(1..10)).each do
    user = User.where(guest: false).sample
    challenge.user_challenges.create!(
      user_id: user.id,
    )
    user.visualizations.sample.update!(challenge:) if user.visualizations.present?
  end
  puts("--#{i + 1}/#{@nb_challenges} challenge created!")
end
puts("----#{@nb_challenges} challenges created!")
