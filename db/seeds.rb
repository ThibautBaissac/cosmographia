require 'faker'

# Create 10 users
10.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password'
  )
end
puts "10 users created!"

# Attach images to 100 maps
100.times do
  map = Map.create!(
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

  image_path = Rails.root.join('db/seeds/images', "sample_#{rand(0..8)}.jpg")
  map.image.attach(
    io: File.open(image_path),
    filename: "sample#{rand(1..5)}.jpg",
    content_type: 'image/jpeg'
  )
end
puts "100 maps created with images!"
