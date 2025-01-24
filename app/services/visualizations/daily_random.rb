class Visualizations::DailyRandom
  def initialize(visualization_count:)
    @visualization_count = visualization_count
  end

  def call
    seed = Digest::MD5.hexdigest(Date.today.to_s).to_i(16) # Generate a seed based on the current date
    visualization_ids = Visualization.pluck(:id)
    visualization_ids.shuffle(random: Random.new(seed)).first(@visualization_count)
  end
end
