require "csv"

namespace :import do
  task softwares: :environment do
    Software.destroy_all
    csv_text = File.read("resources/softwares.csv")
    csv = CSV.parse(csv_text, headers: true, col_sep: ",")
    csv.each do |row|
      puts "--Importing software row : #{row}"
      Software.create!(
        name: row[0],
        category: row[1]
      )
    end
    puts("----Softwares created!")
  end

  task sources: :environment do
    Source.destroy_all
    csv_text = File.read("resources/sources.csv")
    csv = CSV.parse(csv_text, headers: true, col_sep: ",")
    csv.each do |row|
      puts "--Importing source row : #{row}"
      Source.create!(
        name: row[0],
        url: row[1],
        location: row[2],
        description: row[3]
      )
    end
    puts("----Sources created!")
  end
end
