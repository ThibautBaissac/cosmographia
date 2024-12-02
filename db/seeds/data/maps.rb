(0..@nb_maps).each do |i|
  map = Map.create!(
    user_id: User.pluck(:id).sample,
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    creation_date: Faker::Date.backward(days: 365 * 10),
    scale: [ "1000", "5000", "10000", "25000", "50000", "100000", "250000", "500000", "1000000" ].sample,
    sources: Faker::Lorem.sentence(word_count: 5),
    geographic_coverage: Faker::Address.country,
    projection: Map.projection_values.sample,
    is_public: [ true, false ].sample,
    created_at: Faker::Date.backward(days: 365 * 10)
  )

  image_path = Rails.root.join('db/seeds/images', "sample_#{rand(0..8)}.png")
  map.image.attach(
    io: File.open(image_path),
    filename: "sample#{rand(1..5)}.png",
    content_type: 'image/png'
  )

  (0..rand(0..20)).each do
    comment = map.comments.new(
      content: Faker::Lorem.sentence(word_count: 10),
      user_id: User.pluck(:id).sample,
    )
    comment.created_at = Faker::Date.between(from: map.created_at, to: Date.today)
    comment.save!
  end

  (1..rand(1..3)).each do
    map.map_softwares.create!(
      software_id: Software.pluck(:id).sample,
    )
  end

  puts("--(#{i + 1}/#{@nb_maps}) map created!")
end
puts("----#{@nb_maps} maps created!")
