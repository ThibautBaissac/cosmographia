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
        code: row[1]
      )
    end
    puts("----Softwares created!")
  end
end
