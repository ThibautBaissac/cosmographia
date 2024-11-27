(0..@nb_maps).each do |i|
  map = Map.create!(
    user_id: User.pluck(:id).sample,
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    creation_date: Faker::Date.backward(days: 365 * 10),
    scale: rand(1..10000),
    sources: Faker::Lorem.sentence(word_count: 5),
    geographic_coverage: Faker::Address.country,
    projection: [ "Mercator", "Lambert", "Orthographic", "Gnomonic" ].sample,
    coordinate_system: [ "WGS84", "NAD83", "ETRS89" ].sample,
    is_public: [ true, false ].sample
  )

  image_path = Rails.root.join('db/seeds/images', "sample_#{rand(0..8)}.png")
  map.image.attach(
    io: File.open(image_path),
    filename: "sample#{rand(1..5)}.png",
    content_type: 'image/png'
  )
  puts("--(#{i + 1}/#{@nb_maps}) map created!")
end
puts("----#{@nb_maps} maps created!")
