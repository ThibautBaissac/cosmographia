puts("---- Creating feedbasks...")
nb_feedbacks = 20
(0...20).each do |i|
  Feedback.create!(
    user_id: User.pluck(:id).sample,
    subject: Faker::Lorem.sentence,
    message: Faker::Lorem.paragraph
  )
  puts("--#{i + 1}/#{nb_feedbacks} feedback created!")
end
puts("----#{nb_feedbacks} feedbacks created!")
