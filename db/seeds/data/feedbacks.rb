puts("---- Creating feedbasks...")
nb_feedbacks = 20
(0...20).each do |i|
  Feedback.create!(
    user_id: User.pluck(:id).sample,
    subject: Feedback.subject_values.sample,
    message: Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 10),
  )
  puts("--#{i + 1}/#{nb_feedbacks} feedback created!")
end
puts("----#{nb_feedbacks} feedbacks created!")
