puts("---- Creating visualizations...")
image_base_path = Rails.root.join('db/seeds/images')
file_count = Dir[File.join(image_base_path, '*')].count

(0...@nb_visualizations).each do |i|
  creation_date = Faker::Date.between(from: 1.year.ago, to: Date.yesterday)
  visualization = Visualization.new(
    category: Visualization.category_values.sample,
    user_id: User.non_guests.pluck(:id).sample,
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 10, supplemental: true, random_sentences_to_add: 4),
    creation_date: Faker::Date.backward(days: 365),
    scale: [ "1000", "5000", "10000", "25000", "50000", "100000", "250000", "500000", "1000000" ].sample,
    sources: Faker::Lorem.paragraph(sentence_count: 10, supplemental: true, random_sentences_to_add: 4),
    geographic_coverage: Visualization.geographic_coverage_values.sample,
    projection: Visualization.projection_values.sample,
    created_at: creation_date,
    updated_at: creation_date
  )

  random_image_index = rand(1..file_count/2)
  extension = %w[png jpg].sample
  image_path = image_base_path.join("sample_#{random_image_index}.#{extension}")
  visualization.image.attach(
    io: File.open(image_path),
    filename: "sample_#{random_image_index}.#{extension}",
    content_type: "image/#{extension}"
  )
  visualization.save!

  (0..rand(0..20)).each do
    creation_date = Faker::Date.between(from: visualization.created_at, to: Date.today)
    comment = visualization.comments.new(
      content: Faker::Lorem.sentence(word_count: 10),
      user_id: User.non_guests.pluck(:id).sample,
      created_at: creation_date,
      updated_at: creation_date
    )
    comment.save!
  end

  (1..rand(1..3)).each do
    visualization.visualization_softwares.create!(
      software_id: Software.pluck(:id).sample,
    )
  end

  puts("--(#{i + 1}/#{@nb_visualizations}) visualization created!")
end
puts("----#{@nb_visualizations} visualizations created!")
