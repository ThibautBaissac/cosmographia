require 'faker'

10.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password'
  )
end
puts "10 users created!"

100.times do
  Map.create!(
    user_id: User.pluck(:id).sample,
    name: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    creation_date: Faker::Date.backward(days: 365 * 10),
    scale: rand(1..10000),
    sources: Faker::Lorem.sentence(word_count: 5),
    geographic_coverage: Faker::Address.country,
    projection: [ "Mercator", "Lambert", "Orthographic", "Gnomonic" ].sample,
    coordinate_system: [ "WGS84", "NAD83", "ETRS89" ].sample
  )
end
puts "100 maps created!"
